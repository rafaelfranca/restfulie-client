require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.join(File.dirname(__FILE__),'..', '..', 'data','data_helper')

context Restfulie::Client::HTTP::RequestMarshaller do

  it 'shouldnt unmarshal if forcing raw' do
    marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
    raw_response = marshaller.at('/songs').accepts('application/atom+xml').raw.get!
    raw_response.code.should == 200
    raw_response.class.should == Restfulie::Client::HTTP::Response
    raw_response.body.should == response_data( 'atoms', 'songs' )
  end 

  it 'should follow 201 responses' do
    marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
    raw_response = marshaller.at('/custom/songs').as('application/atom+xml').accepts('application/atom+xml').post!("custom")
    raw_response.response.code.should == 200
    raw_response.response.body.should == response_data( 'atoms', 'songs' )
  end 
  
  class Link
    attr_reader :rel
    def initialize(rel)
      @rel = rel
    end
  end
  class Linked
    attr_reader :links
    def initialize(links)
      @links = []
      links.each do |l|
        @links << Link.new(l)
      end
    end
  end
  it 'respond whether a resource contains a rel link' do
    result = Linked.new(["first", "payment"])
    result.extend Restfulie::Client::HTTP::ResponseHolder
    result.respond_to?("search").should be_false
    result.respond_to?("payment").should be_true
  end
  
  it 'should understand a different response content type from its request' do
    result = Restfulie.at('http://localhost:4567/with_content').as("application/xml").post!('<order></order>')
    result.response.headers['content-type'].should == "application/atom+xml"
  end

end

context Restfulie::Client::HTTP::RequestMarshaller do
  
  it "should retrieve any content type if no accepts is specified" do
    result = Restfulie.at('http://localhost:4567/html_result').get!
    result.response.headers['content-type'].should == "text/html"
  end
  
end
