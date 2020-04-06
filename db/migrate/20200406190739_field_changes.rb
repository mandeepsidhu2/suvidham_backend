class FieldChanges < ActiveRecord::Migration[6.0]
  def change
	remove_column :payments, :user_id 
	remove_column :payments, :rfid
	add_column :payments, :rfid, :string
  end
end
