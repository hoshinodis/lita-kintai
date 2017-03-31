require "open-uri"
require "nokogiri"

module Lita
  module Handlers
    class TrainInfo < Handler

      route(/(?<route>.*)(遅|おく)+れてる+(\?|？)/, :call)

      def call(response)
        @@route = response.match_data['route']
        return response.reply("進捗だめで〜す") if @@route == "進捗"

        list = delay_list
        return response.reply(found_route) if list.length == 0
        return response.reply(many_route(list)) if list.length > 1
        response.reply("#{list.first[:name]}: #{cause_delay(list.first)}")
      rescue OpenURI::HTTPError => e
        response.reply("情報がなかったよ。URLが正しいか確認してね。")
        response.reply("今回使用したURL:#{list_url}")
      end


      def route
        @@route = '中央総武線(各停)' if @@route == '総武線'
        @@route
      end

      def cause_delay(route)
        Nokogiri::HTML(open(route[:href]))
            .css('#mdServiceStatus p').text.gsub('http:', 'https:')
      end

      def delay_list
        doc1 = Nokogiri::HTML(open(list_url))
        doc2 = doc1.css("#mdAreaMajorLine .elmTblLstLine > table tr a")
        doc3 = doc2.map { |a| { name: a.content, href: a.attributes["href"].value } }
        doc4 = doc3.select { |site| site[:name].include? route }
      end

      def found_route
        <<-"EOS"
  知らない路線だよ。
  #{list_url}
  から探してね。
        EOS
      end

      def list_url
        "https://transit.yahoo.co.jp/traininfo/area/4/"
      end

      def many_route(routes)
        <<-"EOS"
絞り込めなかったよー。下のどれかかなぁ？
#{routes.map { |route| "  * #{route[:name]}" }.join("\n") }
        EOS
      end

    end

    Lita.register_handler(TrainInfo)
  end
end
