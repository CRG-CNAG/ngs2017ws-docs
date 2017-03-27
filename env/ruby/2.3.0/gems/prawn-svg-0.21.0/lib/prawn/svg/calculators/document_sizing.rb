module Prawn::Svg::Calculators
  class DocumentSizing
    DEFAULT_WIDTH = 300
    DEFAULT_HEIGHT = 150
    DEFAULT_ASPECT_RATIO = "xMidYMid meet"

    attr_writer :document_width, :document_height
    attr_writer :view_box, :preserve_aspect_ratio

    attr_reader :bounds
    attr_reader :x_offset, :y_offset, :x_scale, :y_scale
    attr_reader :viewport_width, :viewport_height, :viewport_diagonal, :output_width, :output_height

    def initialize(bounds, attributes = nil)
      @bounds = bounds
      set_from_attributes(attributes) if attributes
    end

    def set_from_attributes(attributes)
      @document_width = attributes['width']
      @document_height = attributes['height']
      @view_box = attributes['viewBox']
      @preserve_aspect_ratio = attributes['preserveAspectRatio'] || DEFAULT_ASPECT_RATIO
    end

    def calculate
      @x_offset = @y_offset = 0
      @x_scale = @y_scale = 1

      container_width = @requested_width || @bounds[0]
      container_height = @requested_height || @bounds[1]

      @output_width = Pixels.to_pixels(@document_width || @requested_width, container_width)
      @output_height = Pixels.to_pixels(@document_height || @requested_height, container_height)

      if @view_box
        values = @view_box.strip.split(Prawn::Svg::Parser::COMMA_WSP_REGEXP)
        @x_offset, @y_offset, @viewport_width, @viewport_height = values.map {|value| value.to_f}
        @x_offset = -@x_offset

        if @viewport_width > 0 && @viewport_height > 0
          @output_width ||= container_width
          @output_height ||= @output_width * @viewport_height / @viewport_width

          aspect = AspectRatio.new(@preserve_aspect_ratio, [@output_width, @output_height], [@viewport_width, @viewport_height])
          @x_scale = aspect.width / @viewport_width
          @y_scale = aspect.height / @viewport_height
          @x_offset -= aspect.x / @x_scale
          @y_offset -= aspect.y / @y_scale
        end
      else
        @output_width ||= Pixels.to_pixels(DEFAULT_WIDTH, container_width)
        @output_height ||= Pixels.to_pixels(DEFAULT_HEIGHT, container_height)

        @viewport_width = @output_width
        @viewport_height = @output_height
      end

      return if invalid?

      # SVG 1.1 section 7.10
      @viewport_diagonal = Math.sqrt(@viewport_width**2 + @viewport_height**2) / Math.sqrt(2)

      if @requested_width
        scale = @requested_width / @output_width
        @output_width = @requested_width
        @output_height *= scale
        @x_scale *= scale
        @y_scale *= scale

      elsif @requested_height
        scale = @requested_height / @output_height
        @output_height = @requested_height
        @output_width *= scale
        @x_scale *= scale
        @y_scale *= scale
      end

      self
    end

    def invalid?
      @viewport_width <= 0 ||
        @viewport_height <= 0 ||
        @output_width <= 0 ||
        @output_height <= 0 ||
        (@requested_width && @requested_width <= 0) ||
        (@requested_height && @requested_height <= 0)
    end

    def requested_width=(value)
      @requested_width = (value.to_f if value)
    end

    def requested_height=(value)
      @requested_height = (value.to_f if value)
    end
  end
end
