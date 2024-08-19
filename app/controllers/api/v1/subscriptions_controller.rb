class Api::V1::SubscriptionsController < ApplicationController

  rescue_from NoMethodError, with: :bad_request_error

  def create
    if params[:customer].present? && params[:subscription].present?
      customer = Customer.find_by(email: params[:customer])
      subscription = Subscription.find_by(title: params[:subscription])
      CustomerSubscription.create(customer_id: customer.id, subscription_id: subscription.id, status: "active")
      render json: CustomerSerializer.new(customer), status: :created
    else
      missing_params
    end
  end

  def destroy
    if params[:subscription].present?
      customer = Customer.find_by(id: params[:id])
      subscription = Subscription.find_by(title: params[:subscription])
      cust_sub = CustomerSubscription.find_by(customer_id: customer.id, subscription_id: subscription.id)
      cust_sub.update(status: "cancelled")
      render json: CustomerSerializer.new(customer)
    else
      missing_params
    end
  end

  def index
    customer = Customer.find_by(email: params[:customer])
    if params[:customer].present? && customer != nil
      render json: CustomerSerializer.new(customer)
    elsif params[:customer].present?
      bad_request_error
    else
      missing_params
    end
  end

  private

  def missing_params
    render json: ErrorSerializer.new(ErrorMessage.new("Params missing", 400)).serialize_json, status: :bad_request
  end

  def bad_request_error
    render json: ErrorSerializer.new(ErrorMessage.new("Resource not found", 404)).serialize_json, status: :not_found
  end

end