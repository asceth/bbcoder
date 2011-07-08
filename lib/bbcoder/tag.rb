class BBCoder
  class Tag
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options.merge(:as => (options[:as] || name))
    end

    def to_html(meta, content)
      return self.class.reform(name, meta, content) unless content_valid?(content)


      if options[:block].nil?
        "<#{options[:as]}>#{content}</#{options[:as]}>"
      else
        options[:block].binding.eval <<-EOS
          @meta = %Q{#{meta}}
          @content = %Q{#{content}}
        EOS
        options[:block].call
      end
    end

    def content_valid?(content)
      return true if options[:match].nil?

      return !content.match(options[:match]).nil?
    end

    def parents
      options[:parents] || []
    end

    module ClassMethods
      def to_html(tag, meta, content)
        BBCoder.configuration[tag].to_html(meta, content)
      end

      def reform(tag, meta, content = nil)
        if content.nil?
          %(#{reform_open(tag, meta)})
        else
          %(#{reform_open(tag, meta)}#{content}#{reform_end(tag)})
        end
      end

      def reform_open(tag, meta)
        if meta.nil? || meta.empty?
          "[#{tag}]"
        else
          "[#{tag}=#{meta}]"
        end
      end

      def reform_end(tag)
        "[/#{tag}]"
      end
    end
    extend ClassMethods
  end
end
