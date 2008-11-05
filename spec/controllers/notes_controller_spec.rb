require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NotesController do
  define_models
  before { login_as :default }
  
  it 'handles /notes/:id with GET' do
    get :show, :id=>notes(:default)
    response.should be_success
  end
  
  it 'handles /notes with valid params and POST' do
    running {
      post :create, :note=>{:date=>Date.today, :body=>'body'}
      response.should redirect_to(root_path)
    }.should change(Note, :count).by(1)
  end
  
  it 'handles /notes with invalid params and POST' do
    running {
      post :create, :note=>{}
      response.should redirect_to(root_path)
    }.should_not change(Note, :count)
  end
  
  it 'handles /notes/:id with valid params and PUT' do
    note = notes(:default)
    put :update, :id=>note, :note=>{:body=>'update'}
    note.reload.body.should == 'update'
    response.should redirect_to(root_path)
  end
  
  it 'handles /notes/:id with invalid params and PUT' do
    note = notes(:default)
    put :update, :id=>note, :note=>{:body=>''}
    note.reload.body.should_not == ''
    response.should redirect_to(root_path)
  end
  
  it 'handles /notes/:id with DELETE' do
    running {
      delete :destroy, :id=>notes(:default)
      response.should redirect_to(root_path)
    }.should change(Note, :count).by(-1)
  end

end