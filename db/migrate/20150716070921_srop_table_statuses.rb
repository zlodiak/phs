class SropTableStatuses < ActiveRecord::Migration
  def change
    drop_table :statuses
  end
end
