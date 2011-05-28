require "spec_helper"
describe CachedDocument do
  CachedDocument::Config.configuration_file_path = File.expand_path("../fixtures/example_cached_document.yml", __FILE__)
  
  require "fixtures/example.rb"
  before(:each) do
    require "MemCache"
    MemCache.new("localhost:11211").flush_all
  end
  describe " including CachedDocument in a generic class" do
    before(:each) do
      class Example
        include CachedDocument
      end
      @ex = Example.new
    end
    it "adds a method to the class instance methods to retreive the default document" do
      @ex.should respond_to :cached
    end
    describe "#cached" do
      it "returns a Document" do
        @ex.cached.should be_a(CachedDocument::Document)
      end
      it "returns the same document object if called twice in a row" do
        c = @ex.cached
        c.should be @ex.cached
      end
    end
  end
  describe " including CachedDocument in an active model" do
    
  end
  
  describe CachedDocument::Document do
    before(:each) do
      class Example
        include CachedDocument
      end
      @ex = Example.new
      @cached = @ex.cached
    end
    describe "basic flat attributes" do
      it "has a firstname" do
        @cached.should respond_to :firstname
      end
      it "has a firstname of John and a last name of Smith" do
        @cached.firstname.should == "John"
        @cached.lastname.should == "Smith"
      end
      it "has address" do
        @cached.address.city.should == "San Francisco"
      end
    end
  end
  
end
