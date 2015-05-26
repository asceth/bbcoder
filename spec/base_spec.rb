require 'spec_helper'

describe BBCoder do

  subject { BBCoder.new("[p]Text and now [b]bolded.[/b][/p]") }

  context "#configuration" do
    before do
      @tags = BBCoder.configuration.tags.clone
    end

    after do
      BBCoder.configuration.tags = @tags
    end

    it "should return the same object for multiple calls" do
      BBCoder.configuration.should == BBCoder.configuration
    end

    it "should allow to clear the configuration" do
      BBCoder.configuration.clear
      BBCoder.configuration[:spoiler].should be_nil
    end
  end

  context "#buffer" do
    it "should return the same object for multiple calls" do
      subject.buffer.should == subject.buffer
    end
  end

  context "#configure" do
    before do
      @tags = BBCoder.configuration.tags.clone
    end

    after do
      BBCoder.configuration.tags = @tags
    end

    it "should fail without a block" do
      lambda { BBCoder.configure }.should raise_error
    end

    it "should instance_eval the block onto configuration" do
      block = Proc.new { tag :p }
      BBCoder.configure(&block)

      BBCoder.configuration.tags[:p].should_not be_nil
    end

    it "should be able to remove a tag" do
      BBCoder.configure do
        remove :spoiler
      end
      BBCoder.configuration[:spoiler].should be_nil
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
