module Lita
  module Handlers
    class LitaEsa < Handler
       # todo redisで個別に登録できるようにする
      config :esa_api_token, type: String, required: true
      config :esa_team, type: String, required: true

      route(/^esa\s+teams/, :teams)
      def teams(response)
        client = Esa::Client.new(access_token: config.esa_api_token, current_team: config.esa_team)
        post_count = client.posts(per_page: 100).body['total_count']
        wip_count = client.posts(q: 'wip:true').body['total_count']
        reply = client.teams.body['teams']
        response.reply("#{reply}")
      end

      route(/^esa\s+stats/, :stats)
      def stats(response)
        client = Esa::Client.new(access_token: config.esa_api_token, current_team: config.esa_team)
        reply = client.stats.body
        response.reply("#{reply}")
      end

      route(/^esa\s+create\s+post\s+(?<category>.*)\p{blank}+(?<name>.*)\p{blank}+(?<body_md>.[\s\S]*)/, :create_post)
      def create_post(response)
        client = Esa::Client.new(access_token: config.esa_api_token, current_team: config.esa_team)
        client.create_post(
            category: response.match_data['category'],
            name: response.match_data['name'],
            wip: false,
            body_md: response.match_data['body_md']
        )
        response.reply("投稿したよ（投稿したとは言ってない）")
      end

      route(/^esa\s+create\s+test\s+(?<category>.*)\p{blank}+(?<name>.*)\p{blank}+(?<body_md>.[\s\S]*)/, :create_test)
      def create_test(response)
        reply = response.match_data['body_md']
        #reply = response.matches
        response.reply(reply)
      end


      route(/^esa\s+ranking/, :ranking)
      def ranking(response)
        client = Esa::Client.new(access_token: config.esa_api_token, current_team: config.esa_team)

        page_unit = 100
        post_count = client.posts(per_page: page_unit).body['total_count']
        results = (1..((post_count / page_unit) + 1)).each_with_object([]) do |i, results|
          memo = client.posts(per_page: post_count, page: i).body["posts"].group_by{|e|e["created_by"]["screen_name"]}.each_with_object([]) do |e, memo|
            memo << {
                name: e.first,
                number: e.last.count,
                star: e.last.reduce(0) { |a, e|a = a + e["stargazers_count"].to_i }
            }
          end
          results << memo
        end

        response.reply "Posts count ranking"
        results.flatten
            .reduce(Hash.new(0)){ |a, e|a[e[:name]] += e[:number];a }
            .sort { |(k1, v1), (k2, v2)| v2 <=> v1 }
            .chunk { |e| e.last }
            .each.with_index(1) { |e, i|
          names = e.last.map{ |e|e.first }.join(',')
          count = e.first
          response.reply "No.#{i} #{count} - #{names}"
        }

        response.reply "Star count ranking"
        results.flatten
            .reduce(Hash.new(0)){ |a, e|a[e[:name]] += e[:star];a }
            .sort { |(k1, v1), (k2, v2)| v2 <=> v1 }
            .chunk { |e| e.last }
            .each.with_index(1) { |e, i|
          names = e.last.map{ |e|e.first }.join(',')
          count = e.first
          response.reply "No.#{i} #{count} - #{names}"
        }
      end

    end

    Lita.register_handler(LitaEsa)
  end
end
