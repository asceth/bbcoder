require 'spec_helper'

describe BBCoder do

  subject { BBCoder.new("[p]Text and now [b]bolded.[/b][/p]") }

  context "#configuration" do
    it "should return the same object for multiple calls" do
      BBCoder.configuration.should == BBCoder.configuration
    end
  end

  context "#buffer" do
    it "should return the same object for multiple calls" do
      subject.buffer.should == subject.buffer
    end
  end

  context "#configure" do
    it "should fail without a block" do
      lambda { BBCoder.configure }.should raise_error
    end

    it "should instance_eval the block onto configuration" do
      block = Proc.new { tag :p }
      mock(BBCoder).configuration.stub!.instance_eval(&block)
      BBCoder.configure(&block)
    end
  end

  context "#initialize" do
    it "should split tags up properly" do
      subject.raw.should == ["[p]", "Text and now ", "[b]", "bolded.", "[/b]", "[/p]"]
    end

    it "should split tags up properly without content" do
      BBCoder.new("[b][/b][u][/u]").raw.should == ["[b]", "[/b]", "[u]", "[/u]"]
    end
  end

  context "#parse" do
    it "should loop through raw elements and join the buffer" do
      mock(subject).raw.stub!.each {nil}
      mock(subject).buffer.stub!.join {"output"}

      subject.parse
    end
  end
end

