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

See configuration section below on adding new parseable tags


Install
-------

    gem install bbcoder


Autolinking, Smileys, XSS prevention, Newlines
--------------------------------------

bbcoder is not meant to handle smileys, autolinking or xss attacks.  There are other libraries to help do this for us.  I also do not consider these elements part of bbcode itself (even though there is no standard) so bbcoder will not provide support for them except in this README to give examples on how to combine them together.


#### Autolinking
Rails 2.x has a helper auto_link by default that can do this for you.  For Rails 3.x you can install the rails_autolink gem.


#### Smileys
At the moment I use a jquery library to display smileys after the page has loaded.  The library I use https://github.com/JangoSteve/jQuery-CSSEmoticons however it would be nice to see a gem that can parse smileys out of text into appropriate html elements with specific tags.  CSS3 font-face anyone?


#### XSS (currently under review)
Since bbcoder outputs html we have to html_safe it for Rails 3 which can cause problems from a security point of view. I use the Sanitize gem to clean the input before bbcoder transforms it into html.  https://github.com/rgrove/sanitize


#### Newlines
When typing into a textarea a user will use newlines to indicate space between lines.  This is not translated properly into br tags.  I do not consider this a function for bbcoder either atm, however I do use it in combination with XSS/Sanitize above:


##### XSS + Newlines Helper
      def bbcode(text)
        Sanitize.clean(text.to_s).bbcode_to_html.gsub(/\n|\r\n/, "<br />").html_safe
      end


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


