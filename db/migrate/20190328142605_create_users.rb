class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.password_digest :string
      t.remember_digest :string
    end
  end
end
