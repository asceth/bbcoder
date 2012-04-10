require 'spec_helper'

describe BBCoder::Tag do

  context "#meta_valid?" do
    context "with match_meta" do
      before do
        @tag = BBCoder::Tag.new("img", :match_meta => /^.*(png|bmp|jpg|gif)$/)
      end

      it "should return false when tag meta is invalid" do
        @tag.meta_valid?("image.exe", false).should == false
      end

      it "should return true when tag meta is valid" do
        @tag.meta_valid?("image.png", false).should == true
      end

      it "should return true when tag meta is nil" do
        @tag.meta_valid?(nil, false).should == true
      end
    end

    context "with match" do
      before do
        @tag = BBCoder::Tag.new("img", :match => /^.*(png|bmp|jpg|gif)$/)
      end

      it "should return false when tag meta is invalid" do
        @tag.meta_valid?("image.exe", false).should == false
      end

      it "should return true when tag meta is valid" do
        @tag.meta_valid?("image.png", false).should == true
      end

      it "should return true when tag meta is nil" do
        @tag.meta_valid?(nil, false).should == true
      end
    end
  end # #meta_valid?

  context "#content_valid?" do
    context "with match_content" do
      before do
        @tag = BBCoder::Tag.new("strong", :match_content => /^.*(png|bmp|jpg|gif)$/)
        @singular_tag = BBCoder::Tag.new("strong", :match_content => /^.*(png|bmp|jpg|gif)$/, :singular => true)
      end

      it "should return false when tag content is invalid" do
        @tag.content_valid?("image.exe", false).should == false
      end

      it "should return true when tag content is valid" do
        @tag.content_valid?("image.png", false).should == true
      end

      it "should return false if content is nil" do
        @tag.content_valid?(nil, false).should == false
      end

      it "should return true when tag content is nil and tag is singular" do
        @singular_tag.content_valid?(nil, true).should == true
      end
    end

    context "with match" do
      before do
        @tag = BBCoder::Tag.new("strong", :match => /^.*(png|bmp|jpg|gif)$/)
        @singular_tag = BBCoder::Tag.new("strong", :match => /^.*(png|bmp|jpg|gif)$/, :singular => true)
      end

      it "should return false when tag content is invalid" do
        @tag.content_valid?("image.exe", false).should == false
      end

      it "should return true when tag content is valid" do
        @tag.content_valid?("image.png", false).should == true
      end

      it "should return false if content is nil" do
        @tag.content_valid?(nil, false).should == false
      end

      it "should return true when tag content is nil and tag is singular" do
        @singular_tag.content_valid?(nil, true).should == true
      end
    end
  end # #content_valid?
end

