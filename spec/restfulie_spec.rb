require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/server_helper')

class RestfulieModel < ActiveRecord::Base
  def following_states
    {:rel => "next_state", :action => "action_name"}
  end
end

class MockedController
  def url_for(x)
    "http://url_for/#{x[:action]}"
  end
end

describe RestfulieModel do
  
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"following_states\":{\"rel\":\"next_state\",\"action\":\"action_name\"}}")
    end
  end
  
  context "when parsed to xml" do
    it "should not add hypermedia if controller is nil" do
      subject.to_xml.gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model></restfulie-model>')
    end
    it "should add hypermedia atom link if controller is set" do
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>')
    end
    it "should add hypermedia link if controller is set and told to use name based link" do
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <next_state>http://url_for/action_name</next_state></restfulie-model>')
    end
    it "should use action name if there is no rel attribute" do
      def subject.following_states
        [{:action => "next_action"}]
      end
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <next_action>http://url_for/next_action</next_action></restfulie-model>')
    end
  end
  
  context "when adding states" do
    it "should be able to answer to the method rel name" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="pay" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('pay').should eql(true)
    end
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="cancel" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('cancel').should eql(true)
    end
  end

  context "when invoking an state change" do
    it "should send a DELETE request if the state transition name is cancel" do
      @mock_server = MockServer.new(4000, 0.5)
      ["cancel"].each do |method_name|
        method_name = "cancel"
        xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="' + method_name + '" href="http://localhost/order/1"/></restfulie-model>'
        model = RestfulieModel.from_xml xml
        request_received = false
        @mock_server.attach do |env|
          request_received = true
          env['REQUEST_METHOD'].should == "DELETE"
          env['PATH_INFO'].should == "/order/1"
          [ 200, { 'Content-Type' => 'text/plain', 'Content-Length' => '9' }, [ 'Cancelled' ]]
        end
        model.send(method_name)
        request_received.should be_true
        @mock_server.detach
      end
      @mock_server.stop
    end
  end
  
end
