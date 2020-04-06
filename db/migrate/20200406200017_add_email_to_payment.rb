class AddEmailToPayment < ActiveRecord::Migration[6.0]
  def change
  	add_column :payments, :email, :string
  end
end
