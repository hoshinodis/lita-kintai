module Lita
  module Handlers
    class Kintai < Handler
      time = Time.now

      route(/しごはじ/i, :start_work) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def start_work(response)
        start_reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(start_reply)
      end

      route(/しごとわた/i, :end_work)

      def end_work(response)
        end_reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退社しました"
        response.reply(end_reply)
      end
    end

    Lita.register_handler(Kintai)
  end
end
