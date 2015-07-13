module Lita
  module Handlers
    class Kintai < Handler

      route(/しごはじ|お+仕事|しごと+はじめ|始め/, :start_work) 

      def start_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(reply)
      end

      route(/しごとわた|お+仕事|しごと+おしまい/, :end_work)

      def end_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退社しました"
        response.reply(reply)
      end

      route(/しごとおわらない/, :endless_work)

      def endless_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に嘆きました"
        response.reply(reply)
      end

    end

    Lita.register_handler(Kintai)
  end
end
