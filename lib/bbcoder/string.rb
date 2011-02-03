class String
  def bbcode_to_html
    BBCoder.new(self.dup).to_html
  end
end
