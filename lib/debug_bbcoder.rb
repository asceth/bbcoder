require 'bbcoder'

class DebugBBCoder < BBCoder
  def tag_end(tag)
    if DEBUG
      STDERR.puts "tag_end: #{tag}"
      STDERR.puts "open_tags: #{@open_tags.inspect}"
      STDERR.puts "buffer: #{@buffer.inspect}"
    end
    super(tag)
  end

  def tag_open(tag)
    STDERR.puts "tag_open: #{tag}" if DEBUG
    super(tag)
  end

  def finish_buffer
    if DEBUG
      STDERR.puts "finish buffer"
      STDERR.puts "open_tags: #{@open_tags.inspect}"
      STDERR.puts "buffer: #{@buffer.inspect}"
    end

    super
  end
end
