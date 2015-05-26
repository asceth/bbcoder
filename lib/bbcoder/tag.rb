class BBCoder
  class Tag
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options.merge(:as => (options[:as] || name), :singular => (options[:singular] || false))
    end

    def to_html(depth, meta, content, singularity = false)
      unless content_valid?(content, singularity) && meta_valid?(meta, singularity) && link_valid?(meta, content)
        return self.class.reform(name, meta, content, singularity, true)
      end

      if options[:block].nil?
        "<#{options[:as]}>#{content}</#{options[:as]}>"
      else
        options[:block].binding.eval <<-EOS
          @depth = #{depth}
          @meta = %Q{#{Regexp.escape(meta.to_s)}}
          @content = %Q{#{Regexp.escape(content.to_s)}}
          @singularity = #{singularity.to_s}
          def depth; @depth; end
          def meta; @meta; end
          def content; @content; end
          def singular?; @singularity; end
        EOS
        options[:block].call
      end
    end

    def link_valid?(meta, content)
      # only run if we have a :match_link
      return true if options[:match_link].nil?

      if meta.nil? || meta.empty?
        return false if content.match(options[:match_link]).nil?
      else
        return false if meta.match(options[:match_link]).nil?
      end

      return true
    end

    def meta_valid?(meta, singularity)
      return true if meta.nil?

      unless options[:match].nil?
        return false if meta.match(options[:match]).nil?
      end

      unless options[:match_meta].nil?
        return false if meta.match(options[:match_meta]).nil?
      end

      return true
    end

    def content_valid?(content, singularity)
      return true if content.nil? && (options[:singular] && singularity)
      return false if content.nil?

      unless options[:match].nil?
        return false if content.match(options[:match]).nil?
      end

      unless options[:match_content].nil?
        return false if content.match(options[:match_content]).nil?
      end

      return true
    end

    def parents
      options[:parents] || []
    end

    def singular?
      options[:singular]
    end

    module ClassMethods
      def to_html(tag, depth, meta, content, singularity = false)
        BBCoder.configuration[tag].to_html(depth, meta, content, singularity)
      end

      # need #handle so we don't get into a reform loop from to_html
      # checking content validity
      def handle(tag, depth, meta, content = nil, force_end = false)
        if BBCoder.configuration[tag] && BBCoder.configuration[tag].singular?
          to_html(tag, depth, meta, content, true)
        else
          # reform doesn't really care about depth, so we don't pass it in.
          reform(tag, meta, content, force_end)
        end
      end

      def reform(tag, meta, content = nil, singularity = false, force_end = false)
        if (content.nil? && !force_end) || singularity
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
