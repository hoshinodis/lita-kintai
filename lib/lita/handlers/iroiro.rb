module Lita
  module Handlers
    class Iroiro < Handler

      route(/^突然の/i, :suddenly) 
      def suddenly(response)
        word = response.args.join
        word = "死" if word.nil?
        suddenly_word = "＿"
        (word.length + 5).times{suddenly_word += "人"}
        suddenly_word += "＿\n＞ 突然の#{word} ＜\n￣"
        (word.length + 5).times{suddenly_word += "Y^"}
        suddenly_word += "￣"
        response.reply(suddenly_word)
      end

      route(/info message/i, :info_message)
      def info_message(response)
        reply = "#{response.message.source.private_message}\n#{response.reply}"
        response.reply(reply)
      end

      route(/info user/i, :info_user)
      def info_user(response)
        reply = "#{response.user.name}"
        response.reply(reply)
      end
    end

    Lita.register_handler(Iroiro)
  end
end
