require "rails_helper"

describe "subscription create, cancellation, and index" do
  before :each do
    @customer1 = Customer.create(first_name: "James", last_name: "McHugh", email: "james@example.com", address: "123 Main St")
    @customer2 = Customer.create(first_name: "Paulina", last_name: "Goode", email: "paulina@example.com", address: "234 Main St")
    @customer3 = Customer.create(first_name: "Twila", last_name: "Jones", email: "twila@example.com", address: "345 Main St")
    @customer4 = Customer.create(first_name: "Raymond", last_name: "Atwater", email: "raymond@example.com", address: "345 Main St")

    sub1 = Subscription.create(title: "Green Tea Weekly", price: 7.50, frequency: "weekly")
    sub2 = Subscription.create(title: "Black Tea Weekly", price: 7.50, frequency: "weekly")
    sub3 = Subscription.create(title: "Green Tea Monthly", price: 19.99, frequency: "monthly")
    sub4 = Subscription.create(title: "Black Tea Monthly", price: 19.99, frequency: "monthly")

    CustomerSubscription.create(customer_id: @customer1.id, subscription_id: sub4.id, status: "active")
    CustomerSubscription.create(customer_id: @customer3.id, subscription_id: sub3.id, status: "active")
    CustomerSubscription.create(customer_id: @customer4.id, subscription_id: sub2.id, status: "active")
    CustomerSubscription.create(customer_id: @customer4.id, subscription_id: sub3.id, status: "active")

    tea1 = Tea.create(name: "green", description: "high in antioxidants", temperature: 185, brew_time: 3)
    tea2 = Tea.create(name: "black", description: "high in caffeine", temperature: 212, brew_time: 5)

    SubscriptionTea.create(subscription_id: sub1.id, tea_id: tea1.id)
    SubscriptionTea.create(subscription_id: sub2.id, tea_id: tea2.id)
    SubscriptionTea.create(subscription_id: sub3.id, tea_id: tea1.id)
    SubscriptionTea.create(subscription_id: sub4.id, tea_id: tea2.id)
  end

  it "subscribes a customer to a tea subscription" do
    #paulina wasn't assigned any subs in the setup
    post "/api/v1/subscriptions?customer=paulina@example.com&subscription=Black Tea Monthly"

    expect(response).to be_successful
    expect(response.status).to eq(201)

    customer = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(customer[:id]).to eq("#{@customer2.id}")
    expect(customer[:type]).to eq("customer")
    attributes = customer[:attributes]
    expect(attributes[:first_name]).to eq("Paulina")
    expect(attributes[:last_name]).to eq("Goode")
    expect(attributes[:email]).to eq("paulina@example.com")
    expect(attributes[:address]).to eq("234 Main St")
    expect(attributes[:customer_subscriptions][0][:status]).to eq("active")
    new_sub = attributes[:subscriptions][0]
    expect(new_sub[:title]).to eq("Black Tea Monthly")
    expect(new_sub[:price]).to eq(19.99)
    expect(new_sub[:frequency]).to eq("monthly")
  end

  describe "sad path" do
    it "will render serialized error json when params missing" do
      post "/api/v1/subscriptions?customer=paulina@example.com"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)[:errors]

      expect(error[0][:message]).to eq("Params missing")
    end
  end

  it "can cancel a subscription" do
    #james has black tea monthly active sub (and this is the only sub)
    delete "/api/v1/subscriptions/#{@customer1.id}?subscription=Black Tea Monthly"

    expect(response).to be_successful

    customer = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(customer[:attributes][:customer_subscriptions][0][:status]).to eq("cancelled")
  end

  describe "sad path" do
    it "will render serialized error json when params missing" do
      delete "/api/v1/subscriptions/#{@customer1.id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)[:errors]

      expect(error[0][:message]).to eq("Params missing")
    end
  end

  it "can give an index of all customer subscriptions" do
    #raymond has subs to black tea weekly and green tea monthly
    get "/api/v1/subscriptions?customer=raymond@example.com"

    expect(response).to be_successful

    customer = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(customer[:id]).to eq("#{@customer4.id}")
    expect(customer[:type]).to eq("customer")
    
    subs = customer[:attributes][:subscriptions]

    expect(subs.count).to eq(2)
    expect(subs[0]).to have_key :id
    expect(subs[0]).to have_key :title
    expect(subs[0]).to have_key :price
    expect(subs[0]).to have_key :frequency
  end

  describe "sad path" do
    it "will render serialized error json when params missing" do
      get "/api/v1/subscriptions"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)[:errors]

      expect(error[0][:message]).to eq("Params missing")
    end

    it "will render a bad request error when the customer doesn't exist" do
      get "/api/v1/subscriptions?customer=notacustomer"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)[:errors]

      expect(error[0][:message]).to eq("Resource not found")
    end
  end
end