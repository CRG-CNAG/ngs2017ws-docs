# encoding: utf-8
#
# Copyright October 2014, Jesse Doyle. All rights reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.

require 'spec_helper'

describe Prawn::Icon::Parser do
  describe '::format' do
    it 'should return a raw prawn-formatted string on valid input' do
      string = '<icon>fa-arrows</icon>'
      pdf = create_pdf
      formatted = Prawn::Icon::Parser.format(pdf, string)
      match = "<font name=\"fa\"></font>"

      expect(formatted).to eq(match)
    end

    it 'should return unchanged if no icon tags are found' do
      string = <<-EOS
      <link href="#">test</link>
      Here's some sample text.
      <i>more text</i>
      EOS
      pdf = create_pdf
      formatted = Prawn::Icon::Parser.format(pdf, string)

      expect(formatted).to eq(string)
    end

    it 'should return the empty string if given the empty string' do
      string = ''
      pdf = create_pdf
      formatted = Prawn::Icon::Parser.format(pdf, string)

      expect(formatted).to be_empty
    end

    it 'should raise an error when an icon key is invalid' do
      string = '<icon>an invalid key</icon>'
      pdf = create_pdf
      proc = Proc.new { Prawn::Icon::Parser.format(pdf, string) }

      expect(proc).to raise_error(Prawn::Errors::UnknownFont)
    end

    it 'should raise an error when an icon is not found for valid set' do
      string = '<icon>fa-__INVALID__</icon>'
      pdf = create_pdf
      proc = Proc.new { Prawn::Icon::Parser.format(pdf, string) }

      expect(proc).to raise_error(Prawn::Errors::IconNotFound)
    end
  end

  describe '::config_from_tokens' do
    it 'should handle attrs with double quotes' do
      string = '<icon size="20">fa-arrows</icon>'
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      inner = config.first

      expect(inner[:size]).to eq(20.0)
    end

    it 'should handle attrs with single quotes' do
      string = "<icon size='20'>fa-arrows</icon>"
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      inner = config.first

      expect(inner[:size]).to eq(20.0)
    end

    it 'should handle both single/double quotes in same string' do
      string = '<icon color="0099FF" size=\'20\'>fa-arrows</icon>'
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      inner = config.first

      expect(inner[:size]).to eq(20.0)
      expect(inner[:color]).to eq('0099FF')
    end

    it 'should return an array containing only an empty hash' do
      string = '<icon>fa-arrows</icon>'
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      inner = config.first

      expect(config.size).to eq(1)
      expect(inner).to be_empty
    end

    it 'should return an array containing a single hash of attrs' do
      string = '<icon size="12" color="CCCCCC">fa-arrows</icon>'
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      inner = config.first

      expect(config.size).to eq(1)
      expect(inner[:size]).to eq(12.0)
      expect(inner[:color]).to eq('CCCCCC')
    end

    it 'should return an array containing as many hashes as icons' do
      string = <<-EOS
      <icon>fa-arrows</icon>
      <icon>fa-arrows</icon>
      <icon>fa-arrows</icon>
      EOS
      tokens = tokenize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)

      expect(config.size).to eq(3)
    end
  end

  describe '::keys_to_unicode' do
    it 'should return an empty array for empty input' do
      string = ''
      config = []
      content = contentize_string(string)
      pdf = create_pdf
      icons = Prawn::Icon::Parser.keys_to_unicode(pdf, content, config)

      expect(icons).to be_empty
    end

    it 'should return an array with unicode content' do
      string = '<icon>fa-arrows</icon>'
      tokens = tokenize_string(string)
      content = contentize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      pdf = create_pdf
      icons = Prawn::Icon::Parser.keys_to_unicode(pdf, content, config)
      icon = icons.first[:content]

      expect(valid_unicode?(icon)).to be_true
    end

    it 'should return a single array containing attr hash of defaults' do
      # Hash must contain :set and :content by default
      string = '<icon>fa-arrows</icon>'
      tokens = tokenize_string(string)
      content = contentize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      pdf = create_pdf
      icons = Prawn::Icon::Parser.keys_to_unicode(pdf, content, config)
      icon = icons.first

      expect(icon[:set]).to eq(:fa)
      expect(icon[:content]).not_to be_empty
    end

    it 'should handle strings with multiple icons/attrs combinations' do
      string = <<-EOS
      <icon size="20">fa-arrows</icon>
      some filler text
      <icon>fa-arrows</icon>
      <icon size="8" color="0099FF">fa-arrows</icon>
      EOS
      tokens = tokenize_string(string)
      content = contentize_string(string)
      config = Prawn::Icon::Parser.config_from_tokens(tokens)
      pdf = create_pdf
      icons = Prawn::Icon::Parser.keys_to_unicode(pdf, content, config)
      first = icons.first
      second = icons[1]
      third = icons[2]

      expect(icons.size).to eq(3)
      expect(first[:size]).to eq(20.0)
      expect(second[:size]).to be_nil
      expect(third[:size]).to eq(8.0)
      expect(third[:color]).to eq('0099FF')
    end
  end

  describe '::icon_tags' do
    it 'should return valid input as prawn formatted text tags wrapping color tags' do
      icons = [
        { set: :fa, color: 'CCCCCC', content: "\uf001" }
      ]
      tags = Prawn::Icon::Parser.icon_tags(icons)
      match = "<font name=\"fa\"><color rgb=\"CCCCCC\">\uf001</color></font>"

      expect(tags.size).to eq(1)
      expect(tags.first).to eq(match)
    end

    it 'should return valid input as prawn formatted text tags without color' do
      icons = [
        { set: :fa, content: "\uf001" }
      ]
      tags = Prawn::Icon::Parser.icon_tags(icons)
      match = "<font name=\"fa\">\uf001</font>"

      expect(tags.size).to eq(1)
      expect(tags.first).to eq(match)
    end

    it 'should be capable of handling multiple icon fonts' do
      icons = [
        { set: :fa, content: "\uf001" },
        { set: :fi, content: "\uf001" }
      ]
      tags = Prawn::Icon::Parser.icon_tags(icons)
      match1 = "<font name=\"fa\">\uf001</font>"
      match2 = "<font name=\"fi\">\uf001</font>"

      expect(tags.size).to eq(2)
      expect(tags[0]).to eq(match1)
      expect(tags[1]).to eq(match2)
    end
  end
end
