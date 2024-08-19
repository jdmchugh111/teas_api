class Subscription < ApplicationRecord
  has_many :customer_subscriptions
  has_many :subscription_teas
  has_many :teas, through: :subscription_teas

  validates_presence_of :title,
                        :price,
                        :frequency
end
