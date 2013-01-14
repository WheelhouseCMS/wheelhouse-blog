require 'spec_helper'

module Blog
  describe Archive do
    let(:blog) { ::Blog::Blog.new(:path => "/blog") }
    
    it "computes paths for monthly archives" do
      Archive.new(blog, 2012, 1).path.should == "/blog/2012/1"
    end
    
    it "computes paths for yearly archives" do
      Archive.new(blog, 2012).path.should == "/blog/2012"
    end
    
    it "sorts monthly archives" do
      jan_2012 = Archive.new(blog, 2012, 1)
      feb_2013 = Archive.new(blog, 2013, 2)
      dec_2013 = Archive.new(blog, 2013, 12)
      
      [feb_2013, dec_2013, jan_2012].sort.should == [jan_2012, feb_2013, dec_2013]
    end
    
    it "sorts yearly archives" do
      archive_2012 = Archive.new(blog, 2012)
      archive_2013 = Archive.new(blog, 2013)
      archive_2015 = Archive.new(blog, 2015)
      
      [archive_2013, archive_2015, archive_2012].sort.should == [archive_2012, archive_2013, archive_2015]
    end
    
    describe "#invalid?" do
      it "returns false for valid months" do
        Archive.new(blog, 2012, 1).should_not be_invalid
        Archive.new(blog, 2012, 5).should_not be_invalid
        Archive.new(blog, 2012, 12).should_not be_invalid
      end
      
      it "returns true for invalid months" do
        Archive.new(blog, 2012, 0).should be_invalid
        Archive.new(blog, 2012, 13).should be_invalid
      end
      
      it "returns false for yearly archives" do
        Archive.new(blog, 2012).should_not be_invalid
      end
    end
  end
end
