module Lita
  module Handlers
    class Kintai < Handler
      route(/しごはじ/i, :startWork) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def startWork(response)
        time = Time.new
        startResponse = "#{response.user.name}さんが#{time.hour}時にしごはじしました"
        response.reply(startResponse)
      end
    end

    Lita.register_handler(Kintai)
  end
end
