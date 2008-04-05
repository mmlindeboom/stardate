require File.dirname(__FILE__) + '/../test_helper'
require 'tasks_controller'

# Re-raise errors caught by the controller.
class TasksController; def rescue_action(e) raise e end; end

class TasksControllerTest < Test::Unit::TestCase
  fixtures :tasks, :users, :jobs
  
  def setup
    @controller = TasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_login_required
    get :index
    assert_redirected_to login_path
  end

  def test_should_get_index_as_html
    login_as :jordan
    get :index
    assert_response 404
  end
  
  ##########
  # Index XML
  ##########
  def test_should_get_index_as_xml
    login_as :jordan
    get :index, :format=>'xml'
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_offset
    login_as :jordan
    get :index, :format=>'xml', :offset=>1
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_date
    login_as :jordan
    get :index, :format=>'xml', :date=>20070101
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_date_and_offset
    login_as :jordan
    get :index, :format=>'xml', :offset=>1, :date=>20070101
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_job
    login_as :jordan
    get :index, :format=>'xml', :job_id=>jobs(:risi).id
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_job_and_date
    login_as :jordan
    get :index, :format=>'xml', :job_id=>jobs(:risi).id, :date=>20070101
    assert_response :success
    assert assigns(:tasks)
  end
  
  def test_should_get_index_as_xml_with_job_and_date_and_offset
    login_as :jordan
    get :index, :format=>'xml', :job_id=>jobs(:risi).id, :date=>20070101, :offset=>1
    assert_response :success
    assert assigns(:tasks)
  end
  
  ########
  # End index
  ########
  

  def test_should_get_new
    login_as :jordan
    get :new
    assert_response :success
  end

  def test_should_show_task_as_html
    login_as :jordan
    get :show, :id => 1
    assert_response 404
  end

  def test_should_get_edit
    login_as :jordan
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_task
    login_as :jordan
    put :update, :id => 1, :task => { }
    assert_redirected_to job_path(jobs(:risi))
  end
  
  def test_should_destroy_task
    login_as :jordan
    old_count = Task.count
    delete :destroy, :id => tasks(:explain_search)
    assert_equal old_count-1, Task.count
    
    assert_redirected_to job_path(jobs(:risi))
  end
end
