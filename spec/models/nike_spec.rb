require 'spec_helper'

describe Nike do
  before { @nike = nikes(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @nike.user.should == users(:default)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    Run.should have(1).on(Date.new(2008, 1, 1))
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Run.new.should have(1).error_on(:user_id)
  end
  
  it 'should have a date' do
    Run.new.should have(1).error_on(:date)
  end

end