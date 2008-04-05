require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  fixtures :items, :users, :paychecks, :tags, :taggings

  #############################################################################
  #                           C L A S S    M E T H O D S                      #
  #############################################################################
  def test_on
    assert_equal items(:sals, :panera, :starbucks), Item.on(Date.today)
  end
  
  def test_during
    assert_equal items(:sals, :panera, :starbucks), Item.during(Date.today..(Date.today - 6))
    assert_equal items(:sals, :panera, :starbucks), Item.during((Date.today-6)..Date.today)
  end
  
  #############################################################################
  #                            R E L A T I O N S H I P S                      #
  #############################################################################
  def test_user
    assert_equal users(:jordan), items(:sals).user
  end
  
  def test_paycheck
    assert_equal paychecks(:last_week), items(:starbucks).paycheck
  end
  
  def test_taggings
    assert_equal taggings(:sals_pizza, :sals_sals), items(:sals).taggings
  end
  
  def test_tags
    assert_equal tags(:pizza, :sals), items(:sals).tags
  end
  
  def test_tag_names
    assert_equal 'pizza, sals', items(:sals).tag_names
  end
  
  def test_tag_list_for_new
    item = users(:jordan).items.build :date=>Date.today, :value=>10, :description=>'test'
    assert_nil item.tag_list
    item.tag_list = 'testing, one,  two'
    assert_equal 'testing, one,  two', item.tag_list
    assert_equal 'testing, one,  two', item.tag_names
    assert_equal [], item.tags
    assert item.save
    item.reload
    assert_equal 3, item.tags.size
  end
  
  def test_list_for_exisiting
    item = items(:sals)
    assert_equal tags(:pizza, :sals), item.tags
    item.tag_list = 'peanuts, cracker,jacks'
    assert_equal 'peanuts, cracker,jacks', item.tag_list
    assert_equal 'peanuts, cracker,jacks', item.tag_names
    assert item.save
    item.reload
    assert_equal 3, item.tags.size
  end
  
  #############################################################################
  #                                P R O T E C T E D                          #
  #############################################################################
  def test_protect_user_id
    item = items(:sals)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      item.update_attributes(:description=>'new', :user_id=>2)
    end
  end
  
  #############################################################################
  #                          O B J E C T   M E T H O D S                      #
  #############################################################################
  def test_show_calendar_description
    assert_equal "Sal's", items(:sals).calendar_description
  end
  
  def test_show_date_as_calendar_description
    assert_equal Date.today.strftime('%D'), items(:starbucks).calendar_description
  end
  
  def test_explicit_value
    assert_equal '+100', items(:starbucks).explicit_value
    assert_equal -7, items(:panera).explicit_value
  end
  
  #############################################################################
  #                          V A L U E    R E W R I T E R                     #
  #############################################################################
  def test_round_value_assume_negative
    item = items(:sals)
    item.value = "12.99"
    item.save
    assert_equal -13, item.reload.value
  end
  
  def test_use_plus_sign_for_positive
    item = items(:sals)
    item.value = '+4.50'
    item.save
    assert_equal 5, item.reload.value
  end
  
  def test_retain_value
    item = items(:sals)
    item.value = item.value
    item.save
    assert_equal -6, item.reload.value
  end
  
  #############################################################################
  #                              V A L I D A T I O N                          #
  #############################################################################
  def test_presence
    item = Item.new
    assert !item.valid?
    assert_equal @@error[:blank], item.errors.on(:user_id)
    assert_equal @@error[:blank], item.errors.on(:date)
    assert_equal @@error[:blank], item.errors.on(:value)
  end
  
  def test_description_length_less_than_255
    item = Item.new
    item.description = (1..122).to_a.to_s
    assert !item.valid?
    assert_equal "is too long (maximum is 255 characters)", item.errors.on(:description)
  end
  
  def test_non_zero_value
    item = users(:jordan).items.build :date=>Date.today, :value=>0
    assert !item.valid?
    assert_equal "can't be zero", item.errors.on(:value)
  end
  
  #############################################################################
  #                                  D E S T R O Y                            #
  #############################################################################
  def test_destroy
    assert_equal items(:starbucks), paychecks(:last_week).item
    items(:starbucks).destroy
    assert_nil paychecks(:last_week).reload.item_id
    items(:sals).destroy
    assert_raise(ActiveRecord::RecordNotFound){taggings(:sals_pizza)}
  end
  
end
