module Lita
  module Handlers
    class Iroiro < Handler

      route(/^sql\p{blank}+(?<sql_string>.[\s\S]*)/i, :sql_query, command: true)
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
      
      route(/工数見積もり/, :estimate)
      def estimate(response)
        reply_list = %w(過去10年で最高と言われた01年を上回る出来栄えで1995年以来の工数 110年ぶりの当たり機能
                        仕様が強く中々の工数 タフな03年とはまた違い、本来の軽さを備え、これぞ『ザ・見積もり』
                        今も語り継がれる76年や05年に近い工数 柔らかく要件豊かで上質な工数 豊かな要件と程よい期間が調和した工数
                        過去最高と言われた05年に匹敵する50年に一度の工数 2009年と同等の工数 100年に1度の工数とされた03年を超す21世紀最高の工数
                        偉大な繊細さと複雑な要件を持ち合わせ、心地よく、よく熟すことができて健全 みずみずしさが感じられる素晴らしい品質
                        2009年の50年に一度のできを超える工数).freeze
        response.reply(reply_list.sample)
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
        reply_list = %w(わかる それな は～いわかりま～す わかるわ～ わかる、本質からわかる。 
          わかってしまったのだ… そうだよね～ 直感でわかったけど、じっくり考えて深く理解した 
          ん～！まさかそう思ってるひとがまゆしぃ以外にもいたとは！ かなりわかる わかった！一番わかった！ 
          さわやかなわかり わかるという感じか 軽やかなわかり げにげに 自動的にわかった 
          はいまゆしぃわかるわかる わかる～わかるわ～～～ いやでもわかってしまう ✌わかる✌　
          うんわかるよ、女の人ってそうだからすぐ論点ずれていくよね。勘弁して欲しいよね。 
          わかる、グイグイ来る。 そう それ言おうと思ってた わかる気がする うん それを求めてた 全まゆしぃがわかる
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
