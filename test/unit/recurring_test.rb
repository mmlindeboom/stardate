require File.dirname(__FILE__) + '/../test_helper'

class RecurringTest < Test::Unit::TestCase
  fixtures :recurrings, :users

  #############################################################################
  #                            R E L A T I O N S H I P S                      #
  #############################################################################
  def test_user
    assert_equal users(:jordan), recurrings(:rent).user
  end
  
  #############################################################################
  #                                P R O T E C T E D                          #
  #############################################################################
  def test_protect_user_id
    recurring = recurrings(:rent)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      recurring.update_attributes(:description=>'new', :user_id=>2)
    end
  end
  
  
  #############################################################################
  #                          V A L U E    R E W R I T E R                     #
  #############################################################################
  def test_round_value_assume_negative
    recurring = recurrings(:rent)
    recurring.value = "12.99"
    recurring.save
    assert_equal -13, recurring.reload.value
  end
  
  def test_use_plus_sign_for_positive
    recurring = recurrings(:rent)
    recurring.value = '+4.50'
    recurring.save
    assert_equal 5, recurring.reload.value
  end
  
  def test_retain_value
    recurring = recurrings(:rent)
    recurring.value = recurring.value
    recurring.save
    assert_equal -200, recurring.reload.value
  end
  
  #############################################################################
  #                                V A L I D A T I O N                        #
  #############################################################################
  def test_presence
    recurring = Recurring.new
    assert !recurring.valid?
    assert_equal @@error[:blank], recurring.errors.on(:user_id)
    assert_equal @@error[:blank], recurring.errors.on(:value)
  end
  
  def test_numericality_day
    recurring = Recurring.new
    assert !recurring.valid?
    assert_equal @@error[:not_a_number], recurring.errors.on(:day)
  end
  
  def test_day_limits
    recurring = recurrings(:rent)
    recurring.day = 0
    assert !recurring.valid?
    assert_equal "must be between 1 and 28", recurring.errors.on(:day)
    
    recurring.day = 29
    assert !recurring.valid?
    assert_equal "must be between 1 and 28", recurring.errors.on(:day)
  end
  
  def test_limit_100_recurring
    1.upto(100) do |i|
      r = users(:scott).recurrings.create :day=>1, :value=>10, :description=>'test'
    end
    recurring = users(:scott).recurrings.create :day=>1, :value=>10
    assert !recurring.valid?
    assert_equal "too many recurring transactions", recurring.errors.on(:user)
  end
  
end
