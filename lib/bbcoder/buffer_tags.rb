class BBCoder
  class BufferTags
    attr_accessor :buffer, :_internal, :_meta

    def initialize(buffer)
      @buffer = buffer
      @_internal = []
      @_meta = {}
    end

    def push(tag)
      tag, meta = if tag.include?("=")
                    splits = tag.split("=")
                    [splits.shift.to_sym, splits.join]
                  else
                    [tag.to_sym, nil]
                  end

      if criteria_met?(tag)
        _internal.push(tag)
        _meta[size] = meta
      else
        buffer.push(BBCoder::Tag.reform(tag, meta))
      end
    end

    # logic when popping specific tag
    def pop(tag)
      if empty? || !include?(tag)
        buffer.push("[/#{tag}]")
      elsif last == tag
        buffer.push(BBCoder::Tag.to_html(_internal.pop, _meta.delete(size+1), buffer.pop(+1)))
      elsif include?(tag)
        # repeats pop(tag) until we reach the last == tag
        buffer.push([BBCoder::Tag.reform(_internal.pop, _meta.delete(size+1)), buffer.pop(+1)].join)
        pop(tag)
      end
    end

    # orphaned open tags are combined
    def join
      1.upto(size).to_a.collect do
        [BBCoder::Tag.reform(_internal.pop, _meta.delete(size+1)), buffer.pop(+1)].join  # +1 depth modifier for the buffer
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

      required_parents = BBCoder.configuration[tag].parents

      required_parents.empty? || !(_internal & required_parents).empty?
    end
  end
end
