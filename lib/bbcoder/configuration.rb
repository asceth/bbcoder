class BBCoder
  class Configuration
    @@tags = {}

    def [](value)
      @@tags[value]
    end

    def tag(name, options = {}, &block)
      unless block.nil?
        block.binding.eval <<-EOS
          def meta; @meta; end
          def content; @content; end
        EOS
      end
      @@tags[name.to_sym] = BBCoder::Tag.new(name.to_sym, options.merge(:block => block))
    end
  end
end

