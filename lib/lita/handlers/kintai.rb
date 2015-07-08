module Lita
  module Handlers
    class Kintai < Handler
      route(/gyudon/i, :gyudon) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def gyudon(response)
        gyudonList = %w(チーズ キムチ カレー合いかけ ネギ玉 山かけ).freeze
        gyudonPlz = "あ、#{gyudonList.sample}牛丼中盛りツユダクで。"
        response.reply(gyudonPlz)
      end
    end

    Lita.register_handler(Kintai)
  end
end
