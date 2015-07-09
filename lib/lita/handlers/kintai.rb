module Lita
  module Handlers
    class Kintai < Handler
      route(/しごはじ/i, :start_work) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def start_work(response)
        time = Time.new
        start_reply = "#{response.user.name}さんが#{time.hour}時に出社しました"
        response.reply(start_reply)
      end

      route(/しごとわた/i, :end_work)

      def end_work(response)
        time = Time.new
        end_reply = "#{response.user.name}さんが#{time.hour}時に退社しました"
        response.reply(end_reply)
      end
    end

    Lita.register_handler(Kintai)
  end
end
