class ScrapeOpinionsJob < ApplicationJob
  require 'open-uri'
  require 'net/http'
  require 'nokogiri'
  queue_as :default

  def perform()
    url = 'https://www.bodas.net/musica/la-gramola-discotecas-moviles--e15600/opiniones'
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
  end
end