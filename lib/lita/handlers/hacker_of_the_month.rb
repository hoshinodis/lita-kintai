module Lita
  module Handlers
    class HackerOfTheMonth < Handler
      HM = "hacker_of_the_month"
      config :user_id, type: String, required: true

      route(/^hm\s+summary/, :hm_summary)
      def hm_summary(response)
        user_id = response.message.source.user.id.to_s
        user_name = response.user.name

        if user_id == config.user_id
          reply = []
          redis.lrange(HM, 0, -1).each_with_index do |task, index|
            unless task.nil? || task == ''
              s = JSON.parse(task)
              reply << "[#{s['name']}] #{s['reason']}"
            end
          end
          if reply.empty?
            response.reply 'hacker_of_the_month list is empty'
          else
            response.reply(reply.join("\n"))
          end
        else
          reply = "あなたはご主人様ではありませ〜ん"
          response.reply(reply)
        end
      end

      route(/^hm\s+vote\s+(?<name>.*)\p{blank}+(?<reason>.*)$/, :hm_vote)
      def hm_vote(response)

        if response.private_message?
          user_id = response.message.source.user.id.to_s

          name = response.match_data['name']
          reason = response.match_data['reason']
          senpyo = {:id => user_id, :name => name, :reason => reason}
          redis.rpush(HM, senpyo.to_json)
          response.reply_privately("「#{name}」に投票しました")
          response.reply_privately("理由に「#{reason}」を登録しました")
        else
          response.reply_privately("`hm vote @<user_name> <理由>`\nの形式でハッカーオブザマンスに投票してね")
        end

      end

      route(/^hm\s+delete/, :hm_delete)
      def hm_delete(response)

        user_id = response.message.source.user.id.to_s
        user_name = response.user.name

        if user_id == config.user_id
          redis.del HM

          reply = "削除"
          response.reply(reply)
        else
          reply = "あなたはご主人様ではありませ〜ん"
          response.reply(reply)
        end

      end
    end

    Lita.register_handler(HackerOfTheMonth)
  end
end
