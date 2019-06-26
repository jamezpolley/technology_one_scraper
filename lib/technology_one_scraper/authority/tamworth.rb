require 'scraperwiki'
require 'mechanize'

module TechnologyOneScraper
  module Authority
    module Tamworth
      def self.scrape_page(page, info_url_base)
        page.at("table.grid").search("tr.normalRow, tr.alternateRow").each do |tr|
          tds = tr.search("td")
          day, month, year = tds[3].inner_text.split("/").map{|s| s.to_i}

          record = {
            "council_reference" => tds[0].inner_text,
            "date_received" => Date.new(year, month, day).to_s,
            "address" => tds[1].inner_text,
            "description" => tds[6].inner_text,
            "date_scraped" => Date.today.to_s
          }

          # The description of community facilities development can be unhelpful,
          # like just "other", so provide a little helpful context.
          if tds[5].text == "Community Facilities Development"
            record["description"].prepend("Community Facilities Development: ")
          end

          record["info_url"] = info_url_base + CGI.escape(record["council_reference"])

          TechnologyOneScraper.save(record)
        end
      end

      # Implement a click on a link that understands stupid asp.net doPostBack
      def self.click(page, doc)
        href = doc["href"]
        if href =~ /javascript:__doPostBack\(\'(.*)\',\'(.*)'\)/
          event_target = $1
          event_argument = $2
          form = page.form_with(id: "aspnetForm")
          form["__EVENTTARGET"] = event_target
          form["__EVENTARGUMENT"] = event_argument
          form.submit
        else
          # TODO Just follow the link likes it's a normal link
          raise
        end
      end

      def self.scrape_and_save
        period = 'TM'

        base_url = "https://eproperty.tamworth.nsw.gov.au/ePropertyProd/P1/eTrack"
        url = "#{base_url}/eTrackApplicationSearchResults.aspx?Field=S&Period=" + period + "&r=P1.WEBGUEST&f=%24P1.ETR.SEARCH.SL14"
        info_url_base = "#{base_url}/eTrackApplicationDetails.aspx?r=P1.WEBGUEST&f=%24P1.ETR.APPDET.VIW&ApplicationId="

        agent = Mechanize.new

        # Read in a page
        page = agent.get(url)
        current_page_no = 1
        next_page_link = true

        while next_page_link
          scrape_page(page, info_url_base)
          paging = page.at("table.grid tr.pagerRow")
          if paging.nil?
           next_page_link = false
          else
            next_page_link = paging.search("td a").find{|td| td.inner_text == (current_page_no + 1).to_s}
            if next_page_link
              current_page_no += 1
              puts "Getting page #{current_page_no}..."
              page = click(page, next_page_link)
            end
          end
        end
      end
    end
  end
end
