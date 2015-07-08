module Lita
  module Handlers
    class Kintai < Handler
      route(/gyudon/i, :gyudon) # 正規表現にマッチしたら、指定されたメソッド名を呼び出す

      def gyudon(response)
        gyudonPlz = "あ、チーズ牛丼中盛りツユダクで。"
        response.reply(gyudonPlz)
      end

      route(/^tanzaku\s+([^ ]+)/i, :tanzaku) 

      def tanzaku(response)
        negaigoto = response.args[0].chars
        tanzaku = "┏┷┓\n" + negaigoto.map{|item| "┃" + item + "┃\n"}.join + "┗━★"
        response.reply(tanzaku)
      end
    end

    Lita.register_handler(Kintai)
  end
end
