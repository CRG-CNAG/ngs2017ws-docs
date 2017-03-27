# encoding: utf-8

# patterns.rb : Implements axial & radial gradients
#
# Originally implemented by Wojciech Piekutowski. November, 2009
# Copyright September 2012, Alexander Mankuta. All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
#
module Prawn
  module Graphics
    module Patterns
      # @group Stable API

      # Sets the fill gradient from color1 to color2.
      # old arguments: point, width, height, color1, color2, options = {}
      # new arguments: from, to, color1, color1, options = {}
      #            or  from, r1, to, r2, color1, color2, options = {}
      #
      # Option :apply_transformations, if set true, will transform the
      # gradient's co-ordinate space so it matches the current co-ordinate
      # space of the document.  This option will be the default from Prawn v3.
      # The current default, false, will mean if you (for example) scale your
      # document by 2 and put a gradient inside, you will have to manually
      # multiply your co-ordinates by 2 so the gradient is correctly positioned.
      def fill_gradient(*args)
        set_gradient(:fill, *args)
      end

      # Sets the stroke gradient from color1 to color2.
      # old arguments: point, width, height, color1, color2, options = {}
      # new arguments: from, to, color1, color2, options = {}
      #            or  from, r1, to, r2, color1, color2, options = {}
      #
      # Option :apply_transformations, if set true, will transform the
      # gradient's co-ordinate space so it matches the current co-ordinate
      # space of the document.  This option will be the default from Prawn v3.
      # The current default, false, will mean if you (for example) scale your
      # document by 2 and put a gradient inside, you will have to manually
      # multiply your co-ordinates by 2 so the gradient is correctly positioned.
      def stroke_gradient(*args)
        set_gradient(:stroke, *args)
      end

      private

      def set_gradient(type, *grad)
        opts = grad.last.is_a?(Hash) ? grad.pop : {}

        patterns = page.resources[:Pattern] ||= {}

        registry_key = gradient_registry_key grad, opts

        if patterns["SP#{registry_key}"]
          shading = patterns["SP#{registry_key}"]
        else
          unless shading = gradient_registry[registry_key]
            shading = gradient(grad, opts)
            gradient_registry[registry_key] = shading
          end

          patterns["SP#{registry_key}"] = shading
        end

        operator = case type
                   when :fill
                     'scn'
                   when :stroke
                     'SCN'
                   else
                     fail ArgumentError, "unknown type '#{type}'"
                   end

        set_color_space type, :Pattern
        renderer.add_content "/SP#{registry_key} #{operator}"
      end

      def gradient_registry_key(gradient, opts)
        _x1, _y1, x2, y2, transformation = gradient_coordinates(gradient, opts)

        if gradient[1].is_a?(Array) # axial
          [
            transformation,
            x2, y2,
            gradient[2], gradient[3]
          ]
        else # radial
          [
            transformation,
            x2, y2,
            gradient[1],
            gradient[3],
            gradient[4], gradient[5]
          ]
        end.hash
      end

      def gradient_registry
        @gradient_registry ||= {}
      end

      def gradient(args, opts)
        if args.length != 4 && args.length != 6
          fail ArgumentError, "Unknown type of gradient: #{args.inspect}"
        end

        if opts[:apply_transformations].nil? && current_transformation_matrix_with_translation(0, 0) != [1, 0, 0, 1, 0, 0]
          warn "Gradients in Prawn 2.x and lower are not correctly positioned when a transformation has been made to the document.  Pass 'apply_transformations: true' to correctly transform the gradient, or see https://github.com/prawnpdf/prawn/wiki/Gradient-Transformations for more information."
        end

        color1 = normalize_color(args[-2]).dup.freeze
        color2 = normalize_color(args[-1]).dup.freeze

        if color_type(color1) != color_type(color2)
          fail ArgumentError, "Both colors must be of the same color space: #{color1.inspect} and #{color2.inspect}"
        end

        process_color color1
        process_color color2

        shader = ref!(
          :FunctionType => 2,
          :Domain => [0.0, 1.0],
          :C0 => color1,
          :C1 => color2,
          :N => 1.0
        )

        x1, y1, x2, y2, transformation = gradient_coordinates(args, opts)

        if args.length == 4
          coords = [0, 0, x2 - x1, y2 - y1]
        else
          coords = [0, 0, args[1], x2 - x1, y2 - y1, args[3]]
        end

        shading = ref!(
          :ShadingType => args.length == 4 ? 2 : 3, # axial : radial shading
          :ColorSpace => color_space(color1),
          :Coords => coords,
          :Function => shader,
          :Extend => [true, true]
        )

        ref!(
          :PatternType => 2, # shading pattern
          :Shading => shading,
          :Matrix => transformation
        )
      end

      def gradient_coordinates(args, opts)
        x1, y1 = map_to_absolute(args[0])
        x2, y2 = map_to_absolute(args[args.length == 4 ? 1 : 2])

        transformation = if opts[:apply_transformations]
                           current_transformation_matrix_with_translation(x1, y1)
                         else
                           [1, 0, 0, 1, x1, y1]
                         end

        [x1, y1, x2, y2, transformation]
      end
    end
  end
end
