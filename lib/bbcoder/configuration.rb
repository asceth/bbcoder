class BBCoder
  class Configuration
    @@tags = {}

    def [](value)
      @@tags[value]
    end

    def clear
      @@tags = {}
    end

    def remove name
      @@tags.delete(name.to_sym)
    end

    def tag(name, options = {}, &block)
      unless block.nil?
        block.binding.eval <<-EOS
          def meta; @meta; end
          def content; @content; end
          def singular?; @singularity; end
        EOS
      end
      @@tags[name.to_sym] = BBCoder::Tag.new(name.to_sym, options.merge(:block => block))
    end
  end
end

