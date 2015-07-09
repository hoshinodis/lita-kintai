module Lita
  module Handlers
    class Kintai < Handler
      route(/しごはじ/i, :startWork) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def startWork(response)
        time = Time.new
        startReply = "#{response.user.name}さんが#{time.hour}時に出社しました"
        response.reply(startReply)
      end

      route(/しごとわた/i, :endWork)

      def endWork(response)
        time = Time.new
        endReply = "#{response.user.name}さんが#{time.hour}時に退社しました"
        response.reply(endReply)
      end
    end

    Lita.register_handler(Kintai)
  end
end
