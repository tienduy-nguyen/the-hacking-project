require 'nokogiri'
require 'open-uri'

def get_nokogiri_doc(url)
  return Nokogiri::HTML(URI.open(url))
end

def get_info_townhall(url)
  # puts "Loading data.........................."
  # start = Time.now
  doc = get_nokogiri_doc(url)

  # Get Nokogiri node
  city_name_node = doc.xpath('//h1').last
  city_email_node = doc.xpath('//table/tbody/tr[4]/td[2]').first

  # Get info
  city_name = city_name_node.text
  city_email = city_email_node.text

  hash = Hash.new
  hash[city_name] = city_email

  # finish = Time.now
  # puts "Time for scrapping data of #{city_name}: #{(finish-start).round(3)}"
  return hash
end



def get_result_all_city(url)
  # start = Time.now
  doc = get_nokogiri_doc(url)
  all_city_node = doc.xpath('//a[contains(.,".html")]')
  results = []
  all_city_node.each do |city_node|
    city_html = city_node.content
    info = get_info_townhall(url+city_html)
    results.push(info)
  end
  # finish = Time.now
  # puts "Totle time execution for scrapping data of all city: #{(finish-start).round(2)} s"
  return results
end

# Save data to the txt file : data.txt
def save_data
  list = get_result_all_city('https://www.annuaire-des-mairies.com/95/')
  f = File.open("data/city.txt","w")
  # Get date update
  f.puts "-----------------------------------------------"
  f.puts "Data save at #{Time.now}"
  f.puts "-----------------------------------------------"

  list.select {|crypto|
    crypto.each {|k,v| f.puts "#{k} : #{v}"} 
  }
  
  f.close
  puts "Data saved on city.txt"
end


# p get_info_townhall('https://www.annuaire-des-mairies.com/95/ableiges.html')
# p get_result_all_city('https://www.annuaire-des-mairies.com/95/')
save_data()