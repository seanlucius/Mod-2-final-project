# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
image_number = 0

20.times do
  Category.create(name: Faker::Commerce.department, description: Faker::Marketing.buzzwords, image_url: "https://picsum.photos/300/300/?image#{image_number}")
  image_number += 1
end

400.times do
  Product.create(name: Faker::Commerce.product_name, price: rand(5.00...500.00), image_url: "https://picsum.photos/300/300/?image#{image_number}", description: Faker::Marketing.buzzwords)
  image_number += 1
end

category_number = 1
product_number = 1
count = 0
400.times do
  CategoryProduct.create(category_id: category_number, product_id: product_number)
  product_number += 1
  count += 1
  if count == 20
    count = 0
    category_number += 1
  end
end
