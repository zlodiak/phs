class AddFilenameToVideo < ActiveRecord::Migration
  def change
    add_column :users, :filename, :string
  end
end
