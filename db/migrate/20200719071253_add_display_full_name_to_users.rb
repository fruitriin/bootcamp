class AddDisplayFullNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_full_name, :boolean, null: false, default: true
  end
end
