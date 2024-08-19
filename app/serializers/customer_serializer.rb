class CustomerSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :address, :customer_subscriptions, :subscriptions
end
