module Lita
  module Handlers
    class Kintai < Handler

      route(/しごはじ/i, :start_work) 

      def start_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(reply)
      end

      route(/しごとわた/i, :end_work)

      def end_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退社しました"
        response.reply(reply)
      end

      route(/しごとおわらない/i, :endless_work)

      def endless_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に嘆きました"
        response.reply(reply)
      end

    end

    Lita.register_handler(Kintai)
  end
end
