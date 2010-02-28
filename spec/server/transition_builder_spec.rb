require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restfulie::Server::Transition do
  
  class GithubProject
    acts_as_restfulie
  end
  
  context "when creating a transition" do
    it "should create a transition with no status change and action+rel equals to the transition name" do
      GithubProject.new.should_not respond_to(:can_watch?)
      GithubProject.transition.watch
      GithubProject.new.should respond_to(:can_watch?)
      GithubProject.transitions.should include(:watch)
    end
    it "should create a transition with no status change and action+rel equals to the transition name" do
      result = :watching
      expected = mock Restfulie::Server::Transition
      expected.should_receive(:result=).with(result)
      Restfulie::Server::Transition.should_receive(:new).with(:watching).and_return(expected)

      GithubProject.new.should_not respond_to(:can_watching?)
      GithubProject.transition.watching.results_in(result)
      GithubProject.new.should respond_to(:can_watching?)
      GithubProject.transitions.should include(:watching)
    end
    it "should create a transition with no status change and action+rel equals to the transition name" do
      options = { :my_hash => :value }

      expected = mock Restfulie::Server::Transition
      expected.should_receive(:options=).with(options)
      Restfulie::Server::Transition.should_receive(:new).with(:watcher).and_return(expected)

      GithubProject.new.should_not respond_to(:can_watcher?)
      GithubProject.transition.watcher.at(options)
      GithubProject.new.should respond_to(:can_watcher?)
      GithubProject.transitions.should include(:watcher)
    end
  end
  
end