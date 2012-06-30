class Workout < ActiveRecord::Base
  
  belongs_to :user
  
  scope :during, lambda { |date| where date: date }
  scope :on,     lambda { |date| where date: date }
  
  scope :bike,       where(bike: true)
  scope :elliptical, where(elliptical: true)
  scope :nike,       where(nike: true)
  scope :run,        where(run: true)
  
  def to_s
    if bike?
      "Biked #{distance}mi / #{minutes}min"
    elsif elliptical
      "Elliptical #{distance}mi / #{minutes}min"
    elsif nike?
      "Nike Training Club: #{minutes}min - #{description}"
    elsif p90x?
      "P90X #{description} - #{minutes}min"
    elsif run?
      "Ran #{distance}mi / #{minutes}min"
    elsif walk?
      "Walked #{distance}mi / #{minutes}min"
    else
      "Workout"
    end
  end
    
  validates_presence_of :date, :user_id
  
end
