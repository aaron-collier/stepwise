class CreateWalks < ActiveRecord::Migration[8.1]
  def change
    create_table :walks do |t|
      t.references :user,           null: false, foreign_key: true
      t.decimal    :distance_miles, null: false, precision: 8, scale: 2
      t.integer    :steps,          null: false
      t.date       :walked_on,      null: false, default: -> { 'CURRENT_DATE' }
      t.timestamps
    end
  end
end
