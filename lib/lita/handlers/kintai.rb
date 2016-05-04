module Lita
  module Handlers
    class Kintai < Handler

      route(/^がんばるぞい|^しごはじ|((^お仕事|^おしごと)+(はじめ|始め))/, :start_work) 

      def start_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(reply)
      end

      route(/^しごとわた|((^お仕事|^おしごと)+おしまい)/, :end_work)

      def end_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退社しました"
        response.reply(reply)
      end

      route(/(しごと|仕事).*ない$/, :grieve_work)

      def grieve_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に嘆きました"
        response.reply(reply)
      end

    end

    Lita.register_handler(Kintai)
  end
end
