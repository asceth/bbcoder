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

    it "should parse content with ] in it" do
      '[p]Hi :][/p]'.bbcode_to_html.should == '<p>Hi :]</p>'
    end

    it "should parse content with [ in it" do
      '[p]Bye :[[/p]'.bbcode_to_html.should == '<p>Bye :[</p>'
    end

    it "should act cool and parse content with lots of [ and ] in it" do
      '[b]Bye :[ Bye :[ Miss :] [i]American :] wait...[/i] :[]..:()[/b]'.bbcode_to_html.should == '<strong>Bye :[ Bye :[ Miss :] <em>American :] wait...</em> :[]..:()</strong>'
    end

    it "should not downcase content that looks like a tag when being reformed" do
      '[ Miss ]'.bbcode_to_html.should == '[ Miss ]'
    end

    it "should not downcase content that looks like a tag when being reformed" do
      '[/ Mister ]'.bbcode_to_html.should == '[/ Mister ]'
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

    it "should not drop the equal sign in meta" do
      "[url=http://example.com/?Foo=Bar]Link[/url]".bbcode_to_html.should == "<a href=\"http://example.com/?Foo=Bar\">Link</a>"
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

  context "with case-insensitive input" do
    it "should handle upper case tags" do
      "[P]Text and now [B]nested.[/B][/P]".bbcode_to_html.should == "<p>Text and now <strong>nested.</strong></p>"
    end

    it "should handle mixed upper and lower case tags" do
      "[p]Text and now [B]nested.[/b][/P]".bbcode_to_html.should == "<p>Text and now <strong>nested.</strong></p>"
    end
  end

  context "with singular tags" do
    it "should handle one singular tag" do
      "[sub=subscriptage]".bbcode_to_html.should == "<sub>subscriptage</sub>"
    end

    it "should handle multiple singular tags" do
      "[p]I [sub=me] think [sub=thought]; therefore [sup=well] I am[/p]".bbcode_to_html.should == "<p>I <sub>me</sub> think <sub>thought</sub>; therefore <sup>well</sup> I am</p>"
    end

    it "should handle singular tags in non singular form" do
      "[p]I [sub]me[/sub] think [sub]thought[/sub]; therefore [sup]well[/sup] I am[/p]".bbcode_to_html.should == "<p>I <sub>me</sub> think <sub>thought</sub>; therefore <sup>well</sup> I am</p>"
    end

    it "should handle incorrect singular tags" do
      "[img=image.exe]".bbcode_to_html.should == "[img=image.exe]"
    end
  end

  context "with bad matches" do
    it "should handle an img tag match for content" do
      "[img]image.exe[/img]".bbcode_to_html.should == "[img]image.exe[/img]"
    end

    it "should handle an img tag match for meta" do
      "[img=image.exe]".bbcode_to_html.should == "[img=image.exe]"
    end
  end
end

