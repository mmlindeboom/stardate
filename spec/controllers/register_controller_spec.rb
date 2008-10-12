require File.dirname(__FILE__) + '/../spec_helper'

describe RegisterController do
  
  it 'handles /register with GET' do
    login_as :jordan
    get :index
    assigns(:period).first.should == Date.new(Date.today.year, Date.today.month, 1)
    assigns(:period).last.should == Date.civil(Date.today.year, Date.today.month, -1)
    response.should be_success
  end
  
  it 'handles /register/2007/1 with GET' do
    login_as :jordan
    get :index, :year=>2007, :month=>1
    assigns(:period).first.should == Date.new(2007, 1, 1)
    assigns(:period).last.should == Date.civil(2007, 1, 31)
    response.should be_success
  end
  
  it 'handles /register with POST' do
    login_as :jordan
    post :index, :date=>{:year=>2008, :month=>10}
    assigns(:period).first.should == Date.new(2008, 10, 1)
    assigns(:period).last.should == Date.civil(2008, 10, 31)
    response.should be_success
  end
  
end