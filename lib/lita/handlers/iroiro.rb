module Lita
  module Handlers
    class Iroiro < Handler
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
