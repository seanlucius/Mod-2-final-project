# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# image_number = 0
#
# 20.times do
#   Category.create(name: Faker::Commerce.department, description: Faker::Marketing.buzzwords, image_url: "https://picsum.photos/300/300/?image#{image_number}")
#   image_number += 1
# end
#
# 400.times do
#   Product.create(name: Faker::Commerce.product_name, price: rand(5.00...500.00), image_url: "https://picsum.photos/300/300/?image#{image_number}", description: Faker::Marketing.buzzwords)
#   image_number += 1
# end
#
# category_number = 1
# product_number = 1
# count = 0
# 400.times do
#   CategoryProduct.create(category_id: category_number, product_id: product_number)
#   product_number += 1
#   count += 1
#   if count == 20
#     count = 0
#     category_number += 1
#   end
# end
require 'open-uri'
require 'nokogiri'

array = []
titles = []

doc = Nokogiri::HTML(open('https://www.aliexpress.com/category/200217534/speakers.html?spm=2114.11010108.105.24.650c649bikSbyM'))

# Create category
Category.create(name: "Speakers", description: "Awesome speakers!", image_url: "https://cdn.shopify.com/s/files/1/0875/3864/products/S5W_BK_grande.png?v=1551827082")
item_name = nil
price = nil
image_url = nil
doc.css('a.product[title]').each do |a|
    product_page = Nokogiri::HTML(open('https:' + a.attribute('href')))
    product_page.css('h1.product-name').each do |p|
      item_name =  p.content
    end
    product_page.css('span.p-price').each do |price|
        if price.content.include?(' ')
          array << price.content.split(' ').last
        else
          array << price.content
        end
    end
    price = array.last.to_f
    array = []
    product_page.css('a.ui-image-viewer-thumb-frame', 'img[src]').each do |image|
      if image.attribute("src").to_s.include? '640'
        image_url = image.attribute("src").value
      end
    end
    if !item_name.nil? && !price.nil? && !image_url.nil?
      product = Product.create!(name: item_name, price: price, image_url: image_url, description: "None")
      CategoryProduct.create!(category_id: 1, product_id: product.id)
    end
end
