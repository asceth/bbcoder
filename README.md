Features
--------

* Non-regex based (except for the split)
* Handles deep nesting of tags
* Generates good html even from bad input
* Easy configuration to add new tags

* Tags supported by default:

p, b, i, u, s, del, ins, ol, ul, li, dl, dt, dd, quote, code, spoiler, url, img, youtube, sub, sup

Usage
--------

    BBCoder.new(text).to_html
    # or
    "[p]my string[/p]".bbcode_to_html

Install
-------

    gem install bbcoder


Configuration Examples
-----------------------

    BBCoder.configure do
      tag :b, :as => :strong

      tag :sub, :singular => true do
        %(<sub>#{singular? ? meta : content}</sub>)
      end

      tag :sup, :singular => true do
        %(<sup>#{singular? ? meta : content}</sup>)
      end

      tag :ul
      tag :ol
      tag :li, :parents => [:ol, :ul]

      tag :img, :match => /^.*(png|bmp|jpe?g|gif)$/ do
        %(<a href="#{singular? ? meta : content}"><img src="#{singular? ? meta : content}" /></a>)
      end

      tag :code do
        <<-EOS
    <div class="bbcode-code #{meta}">
      <pre>#{content}</pre>
    </div>
        EOS
      end

      tag :url do
        if meta.nil? || meta.empty?
          %(<a href="#{content}">#{content}</a>)
        else
          %(<a href="#{meta}">#{content}</a>)
        end
      end

      remove :spoiler # Removes [spoiler]
    end


Options for #tag

* :as (symbol) -> use this as the html element ([b] becomes strong)
* :match (regex) -> convert this tag and its content to html only if the content and meta matches the regex (see img tag above for example)
* :match_meta (regex) -> same as :match except only for meta
* :match_content (regex) -> same as :match except only for content
* :parents ([symbol]) -> ignore this tag if there is no open tag that matches its parents
* :singular (true|false) -> use this if the tag does not require an ending tag


When you pass a block to #tag it is expecting you to return a string.  You have two variables available to your block:

* meta -> Everything after the '=' in the opening tag (with [quote="Legendary"] meta returns '"Legendary"' and with [quote] meta returns nil)
* content -> Everything between the two tags (with [b]strong arm[/b] content returns 'strong arm')
* singular? -> Tells you if this tag is being parsed in singular form or if it had an ending tag (affects if content has any data)

You can remove all configured tags by calling `BBCoder.configuration.clear`.

Author
------

Original author: John "asceth" Long


