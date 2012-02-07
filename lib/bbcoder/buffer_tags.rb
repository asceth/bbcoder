class BBCoder
  class BufferTags
    attr_accessor :buffer, :_internal, :_meta

    def initialize(buffer)
      @buffer = buffer
      @_internal = []
      @_meta = {}
    end

    def push(original_tag)
      tag, meta = if original_tag.include?("=")
                    splits = original_tag.split("=")
                    [splits.shift.downcase.to_sym, splits.join('=')]
                  else
                    [original_tag.downcase.to_sym, nil]
                  end

      if criteria_met?(tag)
        _internal.push(tag)
        _meta[size] = meta
      else
        buffer.push(BBCoder::Tag.reform(original_tag, meta))
      end
    end

    # logic when popping specific tag
    def pop(original_tag)
      tag = original_tag.downcase.to_sym

      # no more tags left to pop || this tag isn't in the list
      if empty? || !include?(tag)
        buffer.push("[/#{original_tag}]")
      elsif last == tag
        buffer.push(BBCoder::Tag.to_html(_internal.pop, _meta.delete(size+1), buffer.pop(+1)))
      elsif include?(tag)
        # repeats pop(tag) until we reach the last == tag
        buffer.push(join(+1))
        pop(tag)
      end
    end

    # orphaned open tags are combined
    def join(limit = nil)
      limit = size if limit.nil?

      1.upto(limit).to_a.collect do
        # singular tags are caught in the handle method
        [BBCoder::Tag.handle(_internal.pop, _meta.delete(size+1)), buffer.pop(+1)].join  # +1 depth modifier for the buffer
      end.reverse.join
    end

    # delegates to _internal
    def size
      _internal.size
    end

    def empty?
      _internal.empty?
    end

    def last
      _internal.last
    end

    def include?(tag)
      _internal.include?(tag)
    end

    # helper methods
    def criteria_met?(tag)
      return false if BBCoder.configuration[tag].nil?

      parent_criteria_met?(BBCoder.configuration[tag].parents)
    end

    def parent_criteria_met?(parents)
      parents.empty? || !(_internal & parents).empty?
    end
  end
end
