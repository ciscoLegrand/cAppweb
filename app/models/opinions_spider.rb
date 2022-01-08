require 'kimurai'

class OpinionsSpider < Kimurai::Base
  @name = 'opinions_spider'
  @engine = :mechanize

  def self.process(url)
    @start_urls = [url]
    self.crawl!
  end

  def parse(response, url:, data: {})
    response.xpath("//div[@class='pure-u-8-9']").each do |opinion|
      item = {}

      # item[:title]      = opinion.css('p.storefrontReview__title')&.text&.squish
      item[:title]          = opinion.css('p.storefrontReview__title')&.text&.squish
      item[:body]           = opinion.css('p.storefrontReview__description')&.text&.squish
      item[:ratingStar]     = opinion.css('span.mr5')&.text&.squish
      item[:name]           = opinion.css('p.storefrontReview__name')&.text&.squish
      item[:wedding_date]   = opinion.css('small.storefrontItemReview__date')[0]&.text&.squish
      
      Opinion.where(item).first_or_create
    end
  end
end