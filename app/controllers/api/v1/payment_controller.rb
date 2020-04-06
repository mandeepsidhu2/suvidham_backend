require "razorpay"
class Api::V1::PaymentController < ApplicationController
	def payment
		begin
			 payment_info=ActiveSupport::JSON.decode(request.body.read)
			 payment_obj=Payment.new
			 payment_obj.rfid= payment_info['rfid']
			 payment_obj.slot_number= payment_info['slot_number']
			 payment_obj.amount= payment_info['amount']
			 payment_obj.location= payment_info['location']
			 payment_obj.payment_verified= "False"
			 payment_obj.save
			 render json: payment_obj, status: :ok
		rescue StandardError => e
			 print e
		end
		

	end
	def verify_rfid
		 rfid=params[:rfid] 
		 Razorpay.setup('rzp_test_1d6tY6x9cUBF1Z', 'beilTbj2Kf1XUN19vmp1Dw4m')
		begin
		 		payment=Payment.where(rfid: rfid , payment_verified: "False").first

		 		if payment==nil
		 			raise ActiveRecord::RecordNotFound.new("Payment with rfid #{rfid} not found")
		 		elsif payment.razorpay_order_id!=nil
			  		render json: {
    	  				order_id: payment.razorpay_order_id,
    	  				status: 200
   		 				}, status: :ok	
		 		
		 		else
			 		begin
				  		order = Razorpay::Order.create amount: payment.amount, 
				  		currency: "INR", 
				  		receipt: "TEST",
				  		payment_capture: "1"
				  		payment.razorpay_order_id=order.id
				  		payment.save
				  		render json: {
	    	  				order_id: order.id,
	    	  				status: 200
	   		 				}, status: :ok	
					rescue StandardError => e
						puts e
					end
				end
		rescue ActiveRecord::RecordNotFound => e
				render json: {
    	  		error: e.to_s,
    	  		status: 404
   		 		}, status: :not_found
  		end
		
	end


	def verify
		rfid=params[:rfid] 
		Razorpay.setup('rzp_test_1d6tY6x9cUBF1Z', 'beilTbj2Kf1XUN19vmp1Dw4m')
		razorpay_credentials_json=ActiveSupport::JSON.decode(request.body.read)
		razorpay_credentials = {
			razorpay_order_id: razorpay_credentials_json['razorpay_order_id'],
			razorpay_payment_id: razorpay_credentials_json['razorpay_payment_id'],
			razorpay_signature: razorpay_credentials_json['razorpay_signature']
		}
		puts razorpay_credentials
		begin
			payment=Payment.where(rfid: rfid , payment_verified: "False").first
			Razorpay::Utility.verify_payment_signature(razorpay_credentials)
			puts "true"
			payment.razorpay_order_id=razorpay_credentials_json['razorpay_order_id']
			payment.razorpay_payment_id=razorpay_credentials_json['razorpay_payment_id']
			payment.razorpay_signature=razorpay_credentials_json['razorpay_signature']
			payment.payment_verified="True"
	 	 	payment.save
	 	 	puts(payment)
	 	 	render json: payment, status: :ok
	 	rescue StandardError => e
			puts e
	 	end

	end
end
