# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

customer1 = Customer.create(first_name: "James", last_name: "McHugh", email: "james@example.com", address: "123 Main St")
customer2 = Customer.create(first_name: "Paulina", last_name: "Goode", email: "paulina@example.com", address: "234 Main St")
customer3 = Customer.create(first_name: "Twila", last_name: "Jones", email: "twila@example.com", address: "345 Main St")
customer4 = Customer.create(first_name: "Raymond", last_name: "Atwater", email: "raymond@example.com", address: "345 Main St")

sub1 = Subscription.create(title: "Green Tea Weekly", price: 7.50, frequency: "weekly")
sub2 = Subscription.create(title: "Black Tea Weekly", price: 7.50, frequency: "weekly")
sub3 = Subscription.create(title: "Green Tea Monthly", price: 19.99, frequency: "monthly")
sub4 = Subscription.create(title: "Black Tea Monthly", price: 19.99, frequency: "monthly")

CustomerSubscription.create(customer_id: customer1.id, subscription_id: sub4.id, status: "active")
CustomerSubscription.create(customer_id: customer3.id, subscription_id: sub3.id, status: "active")
CustomerSubscription.create(customer_id: customer4.id, subscription_id: sub2.id, status: "active")
CustomerSubscription.create(customer_id: customer4.id, subscription_id: sub3.id, status: "active")

tea1 = Tea.create(name: "green", description: "high in antioxidants", temperature: 185, brew_time: 3)
tea2 = Tea.create(name: "black", description: "high in caffeine", temperature: 212, brew_time: 5)

SubscriptionTea.create(subscription_id: sub1.id, tea_id: tea1.id)
SubscriptionTea.create(subscription_id: sub2.id, tea_id: tea2.id)
SubscriptionTea.create(subscription_id: sub3.id, tea_id: tea1.id)
SubscriptionTea.create(subscription_id: sub4.id, tea_id: tea2.id)