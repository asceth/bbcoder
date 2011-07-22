require 'spec_helper'

describe BBCoder do

  context "with dirty input" do
    it "should parse content with \" in it" do
      '[p]Text phrase: "going away"[/p]'.bbcode_to_html.should == '<p>Text phrase: "going away"</p>'
    end

    it "should parse content with { in it" do
      '[p]OMG :-{[/p]'.bbcode_to_html.should == '<p>OMG :-{</p>'
    end

    it "should parse content with } in it" do
      '[p]OMG :-}[/p]'.bbcode_to_html.should == '<p>OMG :-}</p>'
    end

    it "should parse content with } in it round 2" do
      string = "[quote=weedman]YES I STICKY IT ALL oF YOU WHO DON'T LIKE it SEND YOUR HATE HERE\n\nhttp://www.gamesyn.com/plugin.php?plugin=PrivateMessages&file=message_send.php&id=20&tid=1583\n\n:} have a good day[/quote]"

      result = <<-EOS
<fieldset>
<legend>weedman says</legend>
  <blockquote>
    YES I STICKY IT ALL oF YOU WHO DON\'T LIKE it SEND YOUR HATE HERE\n\nhttp://www.gamesyn.com/plugin.php?plugin=PrivateMessages&file=message_send.php&id=20&tid=1583\n\n:} have a good day
  </blockquote>
</fieldset>
EOS
      string.bbcode_to_html.should == result
    end

    it "should return tags as text on blank content" do
      '[img][/img]'.bbcode_to_html.should == '[img][/img]'
    end
  end

  context "with properly formatted input" do
    it "should parse paragraph statements" do
      "[p]Text and now [p]nested.[/p][/p]".bbcode_to_html.should == "<p>Text and now <p>nested.</p></p>"
    end

    it "should parse paragraph and bold statements" do
      "[p]Text and now [b]nested.[/b][/p]".bbcode_to_html.should == "<p>Text and now <strong>nested.</strong></p>"
    end

    it "should parse a combination of statements" do
      output = "[p]Text and now [b]bold then [i]italics[/i][/b][/p] and then a [quote]Quote[/quote]".bbcode_to_html
      output.should == <<-EOS
<p>Text and now <strong>bold then <em>italics</em></strong></p> and then a <fieldset>
<legend> says</legend>
  <blockquote>
    Quote
  </blockquote>
</fieldset>
EOS
    end

    it "should handle multiple nestings of b elements" do
      "[b]Now I [b] am [b] extremely [b] bold![/b][/b][/b][/b]".bbcode_to_html.should == "<strong>Now I <strong> am <strong> extremely <strong> bold!</strong></strong></strong></strong>"
    end
  end

  context "with incorrectly formatted input" do
    it "should ignore non-matched tag content" do
      "[b][img]http://mybad.com[/img][/b]".bbcode_to_html.should == "<strong>[img]http://mybad.com[/img]</strong>"
    end

    it "should ignore tags without required parents" do
      "[b]Strong list item [li]one of many[/li][/b]".bbcode_to_html.should == "<strong>Strong list item [li]one of many[/li]</strong>"
    end

    it "should ignore un-opened tags" do
      "[p]Text aint it grand![/p][/p]".bbcode_to_html.should == "<p>Text aint it grand!</p>[/p]"
    end

    it "should ignore un-closed tags" do
      "[p]Text aint it grand!".bbcode_to_html.should == "[p]Text aint it grand!"
    end

    it "should ignore un-closed and un-opened tags" do
      "[p]Text aint it grand!".bbcode_to_html.should == "[p]Text aint it grand!"
    end

    it "shouldn't choke on extremely bad input" do
      "[p]Text and [/b] with a [p] and [quote] a [/p] care in sight oh [i] my [/b].".bbcode_to_html.should == "[p]Text and [/b] with a <p> and [quote] a </p> care in sight oh [i] my [/b]."
    end

    it "shouldn't choke on extremely bad input with meta weirdness" do
      "[p]Text and [/b] with a [p] and [quote='Hahah'] a [/p] care in sight oh [i=nometaforyou] my [/b].".bbcode_to_html.should == "[p]Text and [/b] with a <p> and [quote='Hahah'] a </p> care in sight oh [i=nometaforyou] my [/b]."
    end
  end
end

