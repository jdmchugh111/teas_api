class Tea < ApplicationRecord
  has_many :subscription_teas

  validates_presence_of :name,
                        :description,
                        :temperature,
                        :brew_time  
end
