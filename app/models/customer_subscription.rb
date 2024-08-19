class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  belongs_to :subscription

  validates_presence_of :status
end
