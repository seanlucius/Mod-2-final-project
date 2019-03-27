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
require 'watir'

# Category.destroy_all
# CategoryProduct.destroy_all
# Product.destroy_all

def seed_products(product_url, category_name, category_description, category_image_url)
  array = []
  counter = 1

  doc = Nokogiri::HTML(open(product_url))

  # Create category
  category = Category.create(name: category_name, description: category_description, image_url: category_image_url)
  item_name = nil
  price = nil
  image_url = nil
  shipping_time = nil
  product_description = nil
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
      image_list = []
      product_page.css('a.ui-image-viewer-thumb-frame', 'img[src]').each do |image|
        if !image.attribute("src").nil?
          if image.attribute("src").value.include? '640'
            image_list << image.attribute("src").value
          elsif image.attribute("src").value.include? '50'
            image_list << image.attribute("src").value.gsub("50", "640")
          end
        end
        #elsif image.attribute("src").to_s.include? '50'
      end
      # Get product descroption
      product_page.css("meta[name='description']").each do |description|
        product_description = description.attribute('content')
      end
      # Create headless browser to access shipping data
      browser = Watir::Browser.new :chrome, headless: true
      browser.goto 'https:' + a.attribute('href')
      product_page = Nokogiri.parse(browser.html)
      browser.close
      product_page.css('span.promise-time-cont').each do |shipping|
        array << shipping.content
      end
      shipping_time = array.last.to_i
      array = []
      if !item_name.nil? && !price.nil? && !shipping_time.nil? && !product_description.nil? && shipping_time != 0
        puts counter.to_s + " Products Made"
        counter += 1
        product = Product.create!(name: item_name, price: price, description: product_description, shipping_time: shipping_time)
        CategoryProduct.create!(category_id: category.id, product_id: product.id)
        image_list.each do |image|
          Image.create(product_id: product.id, image_url: image)
        end
      end
  end
end

seed_products('https://www.aliexpress.com/category/200002922/habitat-decor.html?site=glo&g=y&needQuery=n', "Reptile Decor", "Give your favorite reptile a naturalistic environment to enjoy", "https://i.pinimg.com/originals/89/23/4e/89234e64d96596c46cb925f994441746.jpg")
seed_products('https://www.aliexpress.com/category/200002926/terrariums.html?site=glo&g=y&needQuery=n', "Reptile Terrariums", "A wide variety of terrariums, enclosures, kits and housing for your reptile", "http://biobubblepets.com/wp-content/uploads/2016/03/Terrarium-Reptile-Bundle-White-800x800.jpg")
seed_products('https://www.aliexpress.com/category/200002906/fish-aquatic-supplies.html?site=glo&g=y&needQuery=n', "Aquatic Supplies", "Choosing the right aquarium supplies, accessories and equipment is one of the first steps in setting up a healthy freshwater tank", "https://www.tsunamienterpriseshi.com/images/CA-Microvue-Kit-Small.jpg")
seed_products('https://www.aliexpress.com/category/200215838/small-animal-supplies.html?site=glo&g=y&needQuery=n', "Dog Supplies", "Shop our collection of dog and puppy supplies, including the latest accessories, toys, crates, collars and more", "https://ae01.alicdn.com/kf/HTB18ldMSFXXXXakaXXXq6xXFXXXv/Pet-Toilet-for-Dogs-Cat-Animals-Lattice-Dog-Toilet-Pet-Shop-Clean-Goods-for-Small-Dogs.jpg_640x640.jpg")
seed_products('https://www.aliexpress.com/category/200002064/bird-supplies.html?site=glo&g=y&needQuery=n', "Bird Supplies", "Your source for bird supplies. Shop for bird cages, food, stands & other great bird products", "https://www.ultimatepetwebsites.com/wp-content/uploads/2017/07/bird-supplies.jpg")
seed_products('https://www.aliexpress.com/category/200002893/dog-toys.html?site=glo&g=y&needQuery=n', "Dog Toys", "Generic Description", "https://ae01.alicdn.com/kf/HTB1gAcWXzvuK1Rjy0Faq6x2aVXaQ/ANSINPARK-popular-Dog-toys-very-funny-stuffed-plush-toys-chewing-toy-of-the-durability-chewing-toy.jpg_640x640.jpg")
seed_products('https://www.aliexpress.com/category/200002071/cat-supplies.html?site=glo&g=y&needQuery=n', "Cat Supplies", "Generic Description", "https://ae01.alicdn.com/kf/HTB1wGWpKkvoK1RjSZFNq6AxMVXas/Free-Shipping-2-color-Cute-Bed-House-Pet-Bed-Soft-Cat-Cuddle-Bed-Lovely-Pet-Supplies.jpg_640x640.jpg")
seed_products('https://www.aliexpress.com/category/200036008/dog-clothing-shoes.html?site=glo&g=y&needQuery=n', "Dog Clothes", "Generic Description", "https://ae01.alicdn.com/kf/HTB1iIgjX6zuK1Rjy0Fpq6yEpFXaT/Clothes-for-Fleece-Sweater-Golden-Retriever-Husky-Labrador-Big-Dog-Clothes-Winter-Pet-Hoodie-Sportswear-Clothing.jpg_640x640.jpg")
