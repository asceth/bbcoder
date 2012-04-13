require 'bbcoder/base'
require 'bbcoder/configuration'
require 'bbcoder/tag'
require 'bbcoder/buffer'
require 'bbcoder/buffer_tags'
require 'bbcoder/string'

BBCoder.configure do
  tag :p
  tag :b, :as => :strong
  tag :i, :as => :em
  tag :u
  tag :s, :as => :strike
  tag :del
  tag :ins
  tag :ol
  tag :ul
  tag :li, :parents => [:ol, :ul]
  tag :dl
  tag :dt, :parents => [:dl]
  tag :dd, :parents => [:dl]

  tag :quote do
    <<-EOS
<fieldset>
<legend>#{meta} says</legend>
  <blockquote>
    #{content}
  </blockquote>
</fieldset>
    EOS
  end

  tag :code do
    <<-EOS
<div class="bbcode-code #{meta}">
  <pre>#{content}</pre>
</div>
    EOS
  end

  tag :spoiler do
    <<-EOS
<fieldset class="bbcode-spoiler">
  <legend>Spoiler</legend>
  <div>#{content}</div>
</fieldset>
    EOS
  end

  tag :url do
    if meta.nil? || meta.empty?
      %(<a href="#{content}">#{content}</a>)
    else
      %(<a href="#{meta}">#{content}</a>)
    end
  end

  tag :img, :match => /^.*(png|bmp|jpe?g|gif)$/, :singular => true do
    %(<a href="#{singular? ? meta : content}"><img src="#{singular? ? meta : content}" /></a>)
  end

  tag :youtube do
    <<-EOS
<iframe width="560" height="349" src="http://www.youtube.com/embed/#{content}" frameborder="0" allowfullscreen></iframe>
    EOS
  end

  tag :sub, :singular => true do
    %(<sub>#{singular? ? meta : content}</sub>)
  end

  tag :sup, :singular => true do
    %(<sup>#{singular? ? meta : content}</sup>)
  end
end

