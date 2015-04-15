class BBCoder
  class Configuration
    attr_accessor :tags

    def initialize
      @tags = {}
    end

    def [](value)
      @tags[value]
    end

    def clear
      @tags = {}
    end

    def remove name
      @tags.delete(name.to_sym)
    end

    def tag(name, options = {}, &block)
      @tags[name.to_sym] = BBCoder::Tag.new(name.to_sym, options.merge(:block => block))
    end
  end
end
