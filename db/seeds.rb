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

def seed_products(product_url, category_name, category_description, category_image_url, category_id)
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
      product_page.css('a.ui-image-viewer-thumb-frame', 'img[src]').each do |image|
        if image.attribute("src").to_s.include? '640'
          image_url = image.attribute("src").value
        end
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
      if !item_name.nil? && !price.nil? && !image_url.nil? && !shipping_time.nil? && !product_description.nil? && shipping_time != 0
        puts counter.to_s + "Product Made"
        counter += 1
        product = Product.create!(name: item_name, price: price, image_url: image_url, description: product_description, shipping_time: shipping_time)
        CategoryProduct.create!(category_id: category.id, product_id: product.id)
      end
  end
end

seed_products('https://www.aliexpress.com/category/200217534/speakers.html?spm=2114.11010108.105.24.650c649bikSbyM', "Speakers", "Awesome speakers!", "https://cdn.shopify.com/s/files/1/0875/3864/products/S5W_BK_grande.png?v=1551827082", 1)
# seed_products('https://www.aliexpress.com/category/63705/earphones-headphones.html?spm=2114.search0103.105.23.67be79cdIccaOG', "Headphones", "Super Cool Headphones and Earphones!!!", "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/M/Q5/MQ562/MQ562?wid=2104&hei=2980&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1502831061423", 2)
# seed_products('https://www.aliexpress.com/category/200010206/smart-watches.html?spm=2114.search0103.105.33.618373c09xm40g', "Smart Watches", "Super Smart!", "https://i5.walmartimages.com/asr/3e11141d-5fad-4a66-a37b-94cfa6243d46_1.a3bfaba9533f2cf74678b9b1e35520df.jpeg?odnHeight=450&odnWidth=450&odnBg=FFFFFF", 3)
# seed_products('https://www.aliexpress.com/w/wholesale-camera-drone.html?spm=2114.search0103.105.40.6c1b3e70rDPpyq&initiative_id=SC_20180114181349&site=glo&g=y&SearchText=camera+drone&needQuery=n&CatId=200116005&isrefine=y', "Drones", "Wow They even have drones :O", "https://images-na.ssl-images-amazon.com/images/I/51SIhgH8B2L._SX425_.jpg", 4)
# seed_products('https://www.aliexpress.com/category/702/laptops.html?spm=2114.search0103.104.10.13d33039BWx9Qg', "Laptops", "Powerful Computers", "http://i.dell.com/sites/imagecontent/videos/en/PublishingImages/xps-15-lt-2018.jpg", 5)
