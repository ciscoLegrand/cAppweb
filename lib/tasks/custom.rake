
require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'csv'
task scrape: :environment do 
  url = 'https://www.bodas.net/musica/la-gramola-discotecas-moviles--e15600/opiniones'
  # puts uri = URI.parse(url)

  # res = Net::HTTP.get_response(uri)
  #  res.body
  #  response = Nokogiri::HTML(res.body)
   doc = Nokogiri::HTML(open(url))

  doc.css(".storefrontReviewsTile").each do |item|
    opinion = {}

    opinion[:title] = item.at_css(".storefrontReviewsTileContent__title")&.text
    opinion[:body] = item.at_css(".storefrontReviewsTileContent__description")&.text
    opinion[:ratingStar] = item.at_css(".rating__count")&.text
    opinion[:name] = item.at_css('.storefrontReviewsTileInfo')&.text
    opinion[:wedding_date] = item.at_css('.storefrontReviewsTileInfo__date')&.text
     Opinion.where(opinion).first_or_create
  end
  puts Opinion.count
end

task import_events: :environment do  
  CSV.foreach(File.join(Rails.root, 'public', 'files','fran21.csv'), headers: true) do |row|
    ca = row[0].split(';') if row[0].present?
    if ca[1].present?
      services = ca[3].present? ? ca[3].split(' + ') : ['gramola']
      
      email = ca[6].blank?  ? "usertemporal@gramola"  : ca[6]
      numbers = Array(0..9)
      phone =""
      9.times do 
        phone << numbers.sample.to_s
      end
      def createtimestamps
        str = Time.now - rand(1..23).hours
        str.strftime('%y%m%d%H%M%S%L')
      end
      user = Cadmin::User.find_by(email: email).present? ? Cadmin::User.find_by(email: email) : Cadmin::User.create!(email: email, password: 'test123', role: 'customer', phone: phone, username: "#{phone}#{createtimestamps}")
      restaurant = Cadmin::Location.find_by(name: ca[1]).present? ? Cadmin::Location.find_by(name: ca[1]) : Cadmin::Location.create!(name: ca[1])
      title = ca[2]
      deposit = ca[12].present? ? ca[12] : 0
      event = Cadmin::Event.create!(customer_id: user.id, cart_id: nil, event_type_id: 1, date: ca[0], place_id: restaurant.id, title: title, deposit: deposit, number: "LGMD/#{user.id.to_s.rjust(6, '0')}-#{createtimestamps}" , observations: 'evento importado de csv')
      services.each do |service|
        if Cadmin::Service.find_by(name: service.capitalize).present?
         Cadmin::EventService.create!(event_id: event.id, service_id: Cadmin::Service.find_by(name: service.capitalize)&.id )
        end
      end
      puts user.id 
      puts restaurant.name
      puts event.inspect
    end
  end

end
