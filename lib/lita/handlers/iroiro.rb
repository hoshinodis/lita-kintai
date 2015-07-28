module Lita
  module Handlers
    class Iroiro < Handler

      route(/^突然の/, :suddenly) 
      def suddenly(response)
        word = response.args.join
        word = "死" if word.nil?
        suddenly_word = "＿"
        (word.length + 2).times{suddenly_word += "人"}
        suddenly_word += "＿\n＞ 突然の#{word} ＜\n￣"
        (word.length).times{suddenly_word += "Y^"}
        suddenly_word += "Y￣"
        response.reply(suddenly_word)
      end

      route(/ねー$|よー$|ね～$|な～$|なー$/, :consent)
      def consent(response)
        reply_list = %w(わかる それな あっ わかるわ～ わかる、本質からわかる。わかってしまったのだ… そうだよね～ 直感でわかったけど、じっくり考えて深く理解した ん～！まさかそう思ってるひとがりったん以外にもいたとは！ かなりわかる わかった！一番わかった！ さわやかなわかり わかるという感じか 軽やかなわかり そう げにげに 自動的にわかった はいりったんわかるわかる わかる～わかるわ～～～ うんわかるよ、女の人ってそうだからすぐ論点ずれていくよね。勘弁して欲しいよね。 知らんがな そう それ言おうと思ってた わかる気がする うん それを求めてた).freeze
        response.reply(reply_list.sample)
      end

      route(/info message/i, :info_message)
      def info_message(response)
        reply = "#{response.matches[0]}\n#{response.matches[0][0]}"
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
