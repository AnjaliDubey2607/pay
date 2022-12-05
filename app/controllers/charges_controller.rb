class ChargesController < ApplicationController
  def index

  end

  def new
  end
    
  def create
    # Amount in cents
    @amount = 500
    Stripe.api_key = "sk_test_51M6rQqSEPNqv3a1zy89NXWTEsgfhDcbbZlcjeer5Fh2BJuugMWTtmjR2nMcJjo0rph93z7TfJvhYx6VZAtfDDh4G0008BlvejH"
    
    customer=""
    Stripe::Customer.list.data.each do |c|
      if c.email==params[:stripeEmail]
          customer=c.id
          break
      end
    end
    
    unless customer.present?
    customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source => params[:stripeToken]
    )
    customer=customer.id
    end
    
    payment_intent = Stripe::PaymentIntent.create(
      :customer => customer,
      :amount => @amount,
      :description => 'Rails Stripe transaction',
      :currency => 'inr',
    )
    # debugger
    Stripe::PaymentIntent.update(
      payment_intent.id,
      {metadata: {order_id: '6735'}},
    )

    Stripe::PaymentIntent.confirm(
      payment_intent.id,
      {payment_method: 'pm_card_visa'},
    )

    redirect_to root_path

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
   
    end

   
end
