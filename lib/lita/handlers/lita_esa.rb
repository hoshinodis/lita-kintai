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

    end

    Lita.register_handler(LitaEsa)
  end
end
