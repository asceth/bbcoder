class BBCoder
  attr_reader :raw

  def self.configure(&block)
    configuration.instance_eval(&block)
  end

  def self.configuration
    @configuration ||= BBCoder::Configuration.new
  end

  def initialize(text)
    @raw = text.split(/(\[[^\[\]]+\])/i).select {|string| string.size > 0}
  end

  def to_html
    @html ||= parse
  end

  def parse
    raw.each do |data|
      case data
      when /\[\/([^\]]+)\]/
        buffer.tags.pop($1) # popping end tag
      when /\[([^\]]+)\]/
        buffer.tags.push($1) # pushing start tag
      else
        buffer.push(data) # content
      end
    end

    buffer.join
  end

  def buffer
    @buffer ||= BBCoder::Buffer.new
  end
end

