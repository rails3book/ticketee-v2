class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :color
      t.string :background
    end

    add_column :tickets, :state_id, :integer
    add_index :tickets, :state_id

    add_column :comments, :state_id, :integer
  end
end
