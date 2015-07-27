module Lita
  module Handlers
    class Iroiro < Handler

      route(/^突然の/i, :suddenly) 
      def suddenly(response)
        word = response.args.join
        suddenly_word = "＿"
        (word.length + 2).times{suddenly_word += "人"}
        suddenly_word += "＿\n＞ #{word} ＜\n￣"
        (word.length + 2).times{suddenly_word += "Y^"}
        suddenly_word += "￣"
        response.reply(suddenly_word)
      end

      route(/info response/i, :info_response)
      def info_response(response)
        reply = "#{response}"
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
