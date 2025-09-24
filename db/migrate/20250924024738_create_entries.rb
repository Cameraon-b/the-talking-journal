class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.string :title
      t.text :content
      t.date :entry_date
      t.time :entry_time
      t.string :tags

      t.timestamps
    end
  end
end
