class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :rfid
      t.integer :amount
      t.integer :slot_number
      t.string :location
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature
      t.string :payment_verified
      t.string :created_on
      t.string :updated_on

      t.timestamps
    end
  end
end
