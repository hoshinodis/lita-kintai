module Lita
  module Handlers
    class Iroiro < Handler

      route(/^sql\p{blank}+(?<sql_string>.[\s\S]*)/i, :sql_query)
      def sql_query(response)
        sql = response.match_data['sql_string']
        result = `mysql -uroot -proot adplan -e'#{sql}'`
        reply = "```\n#{result}\n```"
        response.reply(reply)
      end

      route(/まゆしぃ/, :hello)
      def hello(response)
        reply = "トゥットゥルー"
        response.reply_with_mention(reply)
      end

      route(/収束/, :flag)
      def flag(response)
        reply = "あれー？まゆしぃの懐中時計止まっちゃってる"
        response.reply(reply)
      end

      route(/^突然の.*/, :suddenly) 
      def suddenly(response)
        word = response.matches[0]
        len = word.to_s.split('').map { |c|
              c.bytes.length > 1 ? 2 : 1
              }.inject(:+) / 2
        suddenly_word = "＿#{ '人' * (len + 1) }＿\n" +
                        "＞　#{word}　＜\n" +
                        "￣#{ 'Ｙ^' * (len * 4 / 5) }Ｙ￣"
        response.reply(suddenly_word)
      end

      route(/[ねよな]+(ー$|～$)/, :consent)
      def consent(response)
        reply_list = %w(わかる それな あっ わかるわ～ わかる、本質からわかる。 
          わかってしまったのだ… そうだよね～ 直感でわかったけど、じっくり考えて深く理解した 
          ん～！まさかそう思ってるひとがまゆしぃ以外にもいたとは！ かなりわかる わかった！一番わかった！ 
          さわやかなわかり わかるという感じか 軽やかなわかり そう げにげに 自動的にわかった 
          はいまゆしぃわかるわかる わかる～わかるわ～～～ 
          うんわかるよ、女の人ってそうだからすぐ論点ずれていくよね。勘弁して欲しいよね。 
          知らんがな そう それ言おうと思ってた わかる気がする うん それを求めてた 全まゆしぃがわかる
          ですよね！ ・・・うん それがわかるんだな～ （笑） わからんでもない それいい、心にくる 
          それはわからない 言いすぎ言いすぎ(笑) わかりにく…わかるけどさ…… えっホントに さいですか 
          みんなもわかると思う わかりすぎて声も出ない 逆にね まってまってちょっとついていけてない 
          知るか～～～～～っ！！ すっっっごいわかる たまにある わかるわかるわかる～～ 
          道理は正しいけど感情的には許せないみたいなね、わかる。 とってもよくわかります 
          それめっちゃいい よい あー、あるある 君の気持ちもわからんではないけど、私は相手側の味方だね。その場合。 
          そうかな わかるといえばわかる、わからないといえばわかる。 ごっつわかる 
          あ～そうそう、男ってなんであんな理屈っぽいんだろね わかると言っていい 
          いま名言が来ました…！ それ本に書いてたよね、本に書いてたことそのまま言ったよね 
          またその話か、わかってるって それはもういちいちわかるという必要もない 
          理解できます ア～～～それはしかたないよね だよね、そうなるよね～ 逆にそれすごいと思う ちょ).freeze
        response.reply(reply_list.sample)
      end

      route(/info message/i, :info_message)
      def info_message(response)
        reply = "#{response.matches.join}"
        response.reply(reply)
      end

      route(/info user/i, :info_user)
      def info_user(response)
        reply = "#{response.user.name}"
        user_id = response.message.source.user.id.to_s
        response.reply(reply + ' ' + user_id)
      end
    end

    Lita.register_handler(Iroiro)
  end
end
