require 'spec_helper'

describe BBCoder::Buffer do

  context "#push" do
    it "should append content onto the current depth without increasing depth" do
      subject.push("content")
      subject.push(" + more")
      subject.pop.should == "content + more"
    end
  end

  context "#pop" do
    it "should delete the current depth but not modify the depth" do
      subject.push("content")
      subject.pop
      subject.pop.should == nil
    end
  end

  context "#join" do
    it "should push remaining tags" do
      mock(subject).tags.stub!.join {"joined"}
      mock(subject).push(is_a(String))

      subject.join
    end

    it "should return a string from unopened tags" do
      subject.tags.push("p")
      subject.join.should == "[p]"
    end
  end

  context "#depth" do
    it "should delegate to tags" do
      mock(subject).tags.stub!.size {0}
      subject.depth.should == 0
    end
  end
end

