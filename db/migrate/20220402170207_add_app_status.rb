class AddAppStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :pet_applications, :pet_app_status, :boolean
  end
end
