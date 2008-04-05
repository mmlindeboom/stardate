require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks, :jobs, :paychecks
  
  #############################################################################
  #                           C L A S S    M E T H O D S                      #
  #############################################################################
  def test_on
    assert_equal [tasks(:explain_search), tasks(:today_shift)], Task.on(Date.today)
  end
  
  #############################################################################
  #                            R E L A T I O N S H I P S                      #
  #############################################################################
  def test_job
    assert_equal jobs(:risi), tasks(:explain_search).job
  end
  
  def test_paycheck
    assert_equal paychecks(:last_week), tasks(:today_shift).paycheck
  end
  
  #############################################################################
  #                                H O U R  /  M I N                          #
  #############################################################################
  def test_hour
    assert_nil tasks(:explain_search).hours
    assert_equal 8, tasks(:today_shift).hours
  end
  
  def test_min
    assert_equal 30, tasks(:explain_search).min
    assert_equal '00', tasks(:today_shift).min
  end
  
  #############################################################################
  #                                 P R O T E C T E D                         #
  #############################################################################
  def test_protected
    task = tasks(:explain_search)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      task.update_attributes(:description=>'new', :job_id=>7, :created_at=>1.year.ago)
    end
  end
  
  #############################################################################
  #                                V A L I D A T I O N                        #
  #############################################################################
  def test_presence
    task = Task.new
    assert !task.valid?
    assert_equal @@error[:blank], task.errors.on(:date)
    assert_equal @@error[:blank], task.errors.on(:job_id)
    assert_equal @@error[:blank], task.errors.on(:minutes)
  end
  
  def test_non_zero_minutes
    task = tasks(:explain_search)
    task.minutes = 0
    assert !task.valid?
    assert_equal "can't be zero", task.errors.on(:minutes)
  end
  
  def test_paycheck_must_belong_to_user
    task = tasks(:explain_search)
    task.paycheck = paychecks(:last_week)
    assert !task.valid?
    assert_equal "doesn't belong to the job", task.errors.on(:paycheck)
  end
  
  #############################################################################
  #                             F I X    M I N U T E S                        #
  #############################################################################
  def test_overwrite_just_hours
    task = tasks(:explain_search)
    task.hours = 2
    task.save
    task.reload
    assert_equal 120, task.minutes
  end
  
  def test_overwrite_hours_and_min
    task = tasks(:explain_search)
    task.hours = 1
    task.min = 20
    task.save
    task.reload
    assert_equal 80, task.minutes
  end
  
  def test_overwrite_just_min
    task = tasks(:explain_search)
    task.min = 30
    task.save
    task.reload
    assert_equal 30, task.minutes
  end
  
  def test_new_just_min
    task = Task.new
    task.date = Date.today
    task.job = jobs(:risi)
    task.min = 20
    assert task.valid?
    task.save
    assert_equal 20, task.minutes
  end

end
