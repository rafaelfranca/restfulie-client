require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::SteadyStateWalker do
  
  before do
    @goal = Object.new
    @current = Object.new
    @mikyung = Object.new
    @walker = Restfulie::Client::SteadyStateWalker.new
  end

  it "should throw an error if there is no step to follow" do
    @goal.should_receive(:next_step).with(@current)
    lambda {@walker.move(@goal, @current, @mikyung)}.should raise_error Restfulie::Client::UnableToAchieveGoalError
  end
  
  it "should try to execute the step three times if it is an instantiated object" do
    next_step = Object.new
    @goal.should_receive(:next_step).with(@current).and_return(next_step)
    @walker.should_receive(:try_to_execute).with(next_step, @current, 3, @mikyung).and_return(next_step)
    @walker.move(@goal, @current, @mikyung).should == next_step
  end
  
  class CustomStep
  end
  
  it "should instantiate the step prior to executing it" do
    step = CustomStep
    @goal.should_receive(:next_step).with(@current).and_return(step)

    next_step = CustomStep.new
    CustomStep.should_receive(:new).and_return(next_step)

    @walker.should_receive(:try_to_execute).with(next_step, @current, 3, @mikyung).and_return(next_step)
    @walker.move(@goal, @current, @mikyung).should == next_step
  end
  
end

