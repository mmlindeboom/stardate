require File.dirname(__FILE__) + '/../test_helper'

class PaycheckTest < Test::Unit::TestCase
  fixtures :paychecks, :jobs, :items, :tasks
  
  #############################################################################
  #                         R E L A T I O N S H I P S                         #
  #############################################################################
  def test_item
    assert_equal items(:starbucks), paychecks(:last_week).item
  end
  
  def test_job
    assert_equal jobs(:risi), paychecks(:april).job
  end
  
  def test_tasks
    assert_equal [tasks(:today_shift)], paychecks(:last_week).tasks
  end
  
  #############################################################################
  #                                   P A I D                                 #
  #############################################################################
  def test_paid?
    assert paychecks(:last_week).paid?
    assert !paychecks(:april).paid?
  end
  
  #############################################################################
  #                             P R O T E C T E D                             #
  #############################################################################
  def test_protected
    paycheck = paychecks(:last_week)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      paycheck.update_attributes(:description=>'new', :job_id=>1, :created_at=>1.year.ago, :item_id=>1)
    end
  end
  
  #############################################################################
  #                            V A L I D A T I O N                            #
  #############################################################################
  def test_presence
    paycheck = Paycheck.new
    assert !paycheck.valid?
    assert_equal @@error[:blank], paycheck.errors.on(:job_id)
  end
  
  def test_numericality
    paycheck = paychecks(:april)
    paycheck.value = 'ten'
    assert !paycheck.valid?
    assert_equal @@error[:not_a_number], paycheck.errors.on(:value)
  end
  
  def test_item_and_job_same_user
    paycheck = paychecks(:april)
    paycheck.item = items(:starbucks)
    assert !paycheck.valid?
    assert_equal "doesn't belong to you", paycheck.errors.on(:item)
  end
  
  #############################################################################
  #                      R E C O R D    T R A N S A C T I O N                 #
  #############################################################################
  def test_create_paycheck_not_yet_paid
    paycheck = jobs(:starbucks).paychecks.create :description=>"new", :value=>200
    assert paycheck.valid?
    assert !paycheck.paid?
    assert_nil paycheck.item
  end
  
  def test_create_paycheck_paid_with_checkbox
    paycheck = jobs(:starbucks).paychecks.create :description=>"new", :value=>200, :paid=>1 # A la checkbox
    assert paycheck.valid?
    assert paycheck.paid?
    assert paycheck.item
  end
  
  def test_create_item_on_create_paycheck_paid
    old_paycheck = Paycheck.count
    old_item = Item.count
    paycheck = jobs(:starbucks).paychecks.create :value=>10, :paid=>true
    assert_equal old_paycheck+1, Paycheck.count
    assert_equal old_item+1, Item.count
  end
  
  def test_no_item_on_create_unpaid
    old_paycheck = Paycheck.count
    old_item = Item.count
    paycheck = jobs(:starbucks).paychecks.create :value=>10
    assert_equal old_paycheck+1, Paycheck.count
    assert_equal old_item, Item.count
  end
  
  def test_create_item_on_resave
    old_count = Item.count
    paycheck = paychecks(:april)
    assert paycheck.item.nil?
    paycheck.paid = true
    paycheck.save
    assert old_count + 1, Item.count
    assert paycheck.item
  end
  
  #############################################################################
  #                                  D E S T R O Y                            #
  #############################################################################
  def test_destroy
    paychecks(:last_week).destroy
    assert_nil tasks(:today_shift).paycheck
  end
end
