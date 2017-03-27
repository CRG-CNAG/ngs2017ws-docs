# encoding: utf-8
#
# font_data.rb: Icon font metadata container/cache.
#
# Copyright October 2014, Jesse Doyle. All rights reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.

require 'yaml'

module Prawn
  class Icon
    class FontData
      class << self
        # Font data lazy-loader that will initialize
        # icon fonts by document.
        def load(document, set)
          set = set.to_sym
          @data ||= {}
          @data[set] ||= FontData.new(document, set: set)
          @data[set].load_fonts(document)
        end

        # Release all font references if requested.
        def release_data
          @data = {}
        end

        def unicode_from_key(document, key)
          set = specifier_from_key(key)
          key = key.sub(Regexp.new("#{set}-"), '')
          load(document, set).unicode(key)
        end

        def specifier_from_key(key)
          if key.nil? || key == ''
            raise Prawn::Errors::IconKeyEmpty,
                  'Icon key provided was nil.'
          end

          key.split('-')[0].to_sym
        end
      end

      attr_reader :set

      def initialize(document, opts = {})
        @set = opts[:set] || :fa
        load_fonts(document)
      end

      def font_version
        yaml[specifier]['__font_version__']
      end

      def legend_path
        File.join(File.dirname(path), "#{@set}.yml")
      end

      def load_fonts(document)
        document.font_families[@set.to_s] ||= { normal: path }
        self
      end

      def path
        ttf   = File.join(Icon::FONTDIR, @set.to_s, '*.ttf')
        fonts = Dir[ttf]

        if fonts.empty?
          raise Prawn::Errors::UnknownFont,
                "Icon font not found for set: #{@set}"
        end

        @path ||= fonts.first
      end

      def specifier
        @specifier ||= yaml.keys[0]
      end

      def unicode(key)
        char = yaml[specifier][key]

        unless char
          raise Prawn::Errors::IconNotFound,
                "Key: #{specifier}-#{key} not found"
        end

        char
      end

      def keys
        # Strip the first element: __font_version__
        yaml[specifier].keys.map { |k| "#{specifier}-#{k}" }.drop(1)
      end

      def yaml
        @yaml ||= YAML.load_file legend_path
      end
    end
  end
end
