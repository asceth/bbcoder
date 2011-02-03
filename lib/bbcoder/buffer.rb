class BBCoder
  class Buffer
    attr_accessor :_internal, :tags

    def initialize
      @_internal = {}
      @tags = BBCoder::BufferTags.new(self)
    end

    def push(content)
      _internal[depth] ||= ""
      _internal[depth] += content
    end

    def pop(depth_modifier = 0)
      _internal.delete(depth + depth_modifier)
    end

    # end of processing, insert any orphaned tags without conversion
    def join
      push(tags.join)
    end

    # delegates to tags
    def depth
      tags.size
    end
  end
end

