# frozen_string_literal: true

require "technology_one_scraper/version"
require "technology_one_scraper/authority/blacktown"
require "technology_one_scraper/authority/cockburn"
require "technology_one_scraper/authority/fremantle"
require "technology_one_scraper/authority/kuringgai"
require "technology_one_scraper/authority/lithgow"
require "technology_one_scraper/authority/manningham"
require "technology_one_scraper/authority/marrickville"
require "technology_one_scraper/authority/noosa"
require "technology_one_scraper/authority/port_adelaide"
require "technology_one_scraper/authority/ryde"
require "technology_one_scraper/authority/sutherland"
require "technology_one_scraper/authority/tamworth"
require "technology_one_scraper/authority/wagga"
require "technology_one_scraper/authority/wyndham"

# Scrape the technology one system
module TechnologyOneScraper
  def self.scrape_and_save(authority)
    case authority
    when :blacktown
      Authority::Blacktown.scrape_and_save
    when :cockburn
      Authority::Cockburn.scrape_and_save
    when :fremantle
      Authority::Fremantle.scrape_and_save
    when :kuringgai
      Authority::Kuringgai.scrape_and_save
    when :lithgow
      Authority::Lithgow.scrape_and_save
    when :manningham
      Authority::Manningham.scrape_and_save
    when :marrickville
      Authority::Marrickville.scrape_and_save
    when :noosa
      Authority::Noosa.scrape_and_save
    when :port_adelaide
      Authority::PortAdelaide.scrape_and_save
    when :ryde
      Authority::Ryde.scrape_and_save
    when :sutherland
      Authority::Sutherland.scrape_and_save
    when :tamworth
      Authority::Tamworth.scrape_and_save
    when :wagga
      Authority::Wagga.scrape_and_save
    when :wyndham
      Authority::Wyndham.scrape_and_save
    else
      raise "Unexpected authority: #{authority}"
    end
  end
end
