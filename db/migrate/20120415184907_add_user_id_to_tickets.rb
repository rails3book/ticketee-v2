class AddUserIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :user_id, :integer
    add_index :tickets, :user_id
  end
end
