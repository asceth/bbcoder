class BBCoder
  class Tag
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options.merge(:as => (options[:as] || name), :singular => (options[:singular] || false))
    end

    def to_html(meta, content, singularity = false)
      return self.class.reform(name, meta, content, true) unless content_valid?(content)

      if options[:block].nil?
        "<#{options[:as]}>#{content}</#{options[:as]}>"
      else
        options[:block].binding.eval <<-EOS
          @meta = %Q{#{Regexp.escape(meta.to_s)}}
          @content = %Q{#{Regexp.escape(content.to_s)}}
          @singularity = #{singularity.to_s}
        EOS
        options[:block].call
      end
    end

    def content_valid?(content)
      return true if content.nil? && options[:singular]
      return false if content.nil?
      return true if options[:match].nil?

      return !content.match(options[:match]).nil?
    end

    def parents
      options[:parents] || []
    end

    def singular?
      options[:singular]
    end

    module ClassMethods
      def to_html(tag, meta, content, singularity = false)
        BBCoder.configuration[tag].to_html(meta, content, singularity)
      end

      # need #handle so we don't get into a reform loop from to_html
      # checking content validity
      def handle(tag, meta, content = nil, force_end = false)
        if BBCoder.configuration[tag] && BBCoder.configuration[tag].singular?
          to_html(tag, meta, content, true)
        else
          reform(tag, meta, content, force_end)
        end
      end

      def reform(tag, meta, content = nil, force_end = false)
        if content.nil? && !force_end
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
