module Lita
  module Handlers
    class Iroiro < Handler

      route(/^sql\p{blank}+(?<sql_string>.[\s\S]*)/i, :sql_query, command: true)
      def sql_query(response)
        sql = response.match_data['sql_string']
        sql = '' if(sql.downcase.include?('create') || sql.downcase.include?('delete') || sql.downcase.include?('drop') || sql.downcase.include?('truncate') || sql.downcase.include?('update'))
        
        result = `mysql -uroot -proot adplan -e'#{sql}'`
        reply = "```\n#{result}\n```"
        response.reply(reply)
      end

      route(/まゆしぃ/, :hello)
      def hello(response)
        reply = "トゥットゥルー"
        response.reply_with_mention(reply)
      end

      route(/こうぺん/, :koutei_panda)
      def koutei_panda(response)
        reply_list = %w(https://twitter.com/kosatsuneDQX/status/968482592977596417 https://twitter.com/kosatsuneDQX/status/970295845894594561 https://twitter.com/kosatsuneDQX/status/983677371466182657
                        https://twitter.com/kosatsuneDQX/status/968844166896603136 https://twitter.com/kosatsuneDQX/status/970655586856521728 https://twitter.com/kosatsuneDQX/status/984068448366936066
                        https://twitter.com/kosatsuneDQX/status/969183054739550208 https://twitter.com/kosatsuneDQX/status/971014195696123904 https://twitter.com/kosatsuneDQX/status/984454777990819841
                        https://twitter.com/kosatsuneDQX/status/969195146192416768 https://twitter.com/kosatsuneDQX/status/971386458744373249 https://twitter.com/kosatsuneDQX/status/985135126827814913
                        https://twitter.com/kosatsuneDQX/status/969538525791100928 https://twitter.com/kosatsuneDQX/status/971691968773287939 https://twitter.com/kosatsuneDQX/status/986943614709186561
                        https://twitter.com/kosatsuneDQX/status/969942697552183296 https://twitter.com/kosatsuneDQX/status/971728285871689729 https://twitter.com/kosatsuneDQX/status/987698634824142849
                        https://twitter.com/kosatsuneDQX/status/972108197187108865 https://twitter.com/kosatsuneDQX/status/972477537266708481 https://twitter.com/kosatsuneDQX/status/988414254351970306
                        https://twitter.com/kosatsuneDQX/status/972834663730262018 https://twitter.com/kosatsuneDQX/status/973190486855794689 https://twitter.com/kosatsuneDQX/status/989526762135502848
                        https://twitter.com/kosatsuneDQX/status/973573135248236545 https://twitter.com/kosatsuneDQX/status/973920562044006400 https://twitter.com/kosatsuneDQX/status/992413734835441664
                        https://twitter.com/kosatsuneDQX/status/974283751499841536 https://twitter.com/kosatsuneDQX/status/974651682066870272 https://twitter.com/kosatsuneDQX/status/992761009575116800
                        https://twitter.com/kosatsuneDQX/status/975025167930765312 https://twitter.com/kosatsuneDQX/status/975385750513446913 https://twitter.com/kosatsuneDQX/status/995307225018126336
                        https://twitter.com/kosatsuneDQX/status/976118137065099264 https://twitter.com/kosatsuneDQX/status/976473277752262657 https://twitter.com/kosatsuneDQX/status/996035468478197767
                        https://twitter.com/kosatsuneDQX/status/976830517533294592 https://twitter.com/kosatsuneDQX/status/977207569906200577 https://twitter.com/kosatsuneDQX/status/996771232996470784
                        https://twitter.com/kosatsuneDQX/status/977886107240050689 https://twitter.com/kosatsuneDQX/status/978634308775591941 https://twitter.com/kosatsuneDQX/status/997487588020666374
                        https://twitter.com/kosatsuneDQX/status/979374667063476224 https://twitter.com/kosatsuneDQX/status/979678244839374850 https://twitter.com/kosatsuneDQX/status/998197781972992000
                        https://twitter.com/kosatsuneDQX/status/980371567090675712 https://twitter.com/kosatsuneDQX/status/981146153331785728 https://twitter.com/kosatsuneDQX/status/1000740304054439936
                        https://twitter.com/kosatsuneDQX/status/981506725441236992 https://twitter.com/kosatsuneDQX/status/982274839959318528 https://twitter.com/kosatsuneDQX/status/1001556900352180224
                        https://twitter.com/kosatsuneDQX/status/1002901793620164608 https://twitter.com/kosatsuneDQX/status/1004359545215279105 https://twitter.com/kosatsuneDQX/status/1005460500795150339
                        https://twitter.com/kosatsuneDQX/status/1005789510431461377 https://twitter.com/kosatsuneDQX/status/1008734907110051841 https://twitter.com/kosatsuneDQX/status/1009458841707114496
                        https://twitter.com/kosatsuneDQX/status/1014183177840091136 https://twitter.com/kosatsuneDQX/status/1015594000751812608 https://twitter.com/kosatsuneDQX/status/1018044511421792256
                        https://twitter.com/kosatsuneDQX/status/1021795647274414081 https://twitter.com/kosatsuneDQX/status/1022081392262299648 https://twitter.com/kosatsuneDQX/status/1029399132190851074
                        https://twitter.com/kosatsuneDQX/status/1030831984342315017 https://twitter.com/kosatsuneDQX/status/1031916833174052865 https://twitter.com/kosatsuneDQX/status/1034048319079608320
                        https://twitter.com/kosatsuneDQX/status/1037097545657344000
                        https://twitter.com/k_r_r_l_l_/status/1039627614745374722 https://twitter.com/k_r_r_l_l_/status/1038578221371932679 https://twitter.com/k_r_r_l_l_/status/1037815438992846848 https://twitter.com/k_r_r_l_l_/status/1037681509790969857
                        https://twitter.com/k_r_r_l_l_/status/1037457602269962241 https://twitter.com/k_r_r_l_l_/status/1037100588884873216 https://twitter.com/k_r_r_l_l_/status/1036999416018661376 https://twitter.com/k_r_r_l_l_/status/1036728387014811648
                        https://twitter.com/k_r_r_l_l_/status/1036371830339067904 https://twitter.com/k_r_r_l_l_/status/1036026184222498816 https://twitter.com/k_r_r_l_l_/status/1035106790638157825 https://twitter.com/k_r_r_l_l_/status/1034553929655173120
                        https://twitter.com/k_r_r_l_l_/status/1034191608789364736 https://twitter.com/k_r_r_l_l_/status/1033829108709384194 https://twitter.com/k_r_r_l_l_/status/1032024596877176832 https://twitter.com/k_r_r_l_l_/status/1031664101913575424
                        https://twitter.com/k_r_r_l_l_/status/1030939171769081856 https://twitter.com/k_r_r_l_l_/status/1030590782003077121 https://twitter.com/k_r_r_l_l_/status/1030205304095498240 https://twitter.com/k_r_r_l_l_/status/1029845201894834176
                        https://twitter.com/k_r_r_l_l_/status/1029482886380978176 https://twitter.com/k_r_r_l_l_/status/1029118242516652032 https://twitter.com/k_r_r_l_l_/status/1028396523124449280 https://twitter.com/k_r_r_l_l_/status/1028236310706679809
                        https://twitter.com/k_r_r_l_l_/status/1026951241211863040 https://twitter.com/k_r_r_l_l_/status/1026848264270696448 https://twitter.com/k_r_r_l_l_/status/1026583949374410752 https://twitter.com/k_r_r_l_l_/status/1026221365517410304
                        https://twitter.com/k_r_r_l_l_/status/1025870965178126336 https://twitter.com/k_r_r_l_l_/status/1025506394747809793 https://twitter.com/k_r_r_l_l_/status/1025139344242163713 https://twitter.com/k_r_r_l_l_/status/1024769562342912001
                        https://twitter.com/k_r_r_l_l_/status/1024414221390499840 https://twitter.com/k_r_r_l_l_/status/1022597429000953856 https://twitter.com/k_r_r_l_l_/status/1022240239580938240 https://twitter.com/k_r_r_l_l_/status/1021168443272265729
                        https://twitter.com/k_r_r_l_l_/status/1020428267793203200 https://twitter.com/k_r_r_l_l_/status/1020060714218606593 https://twitter.com/k_r_r_l_l_/status/1019703535556935680 https://twitter.com/k_r_r_l_l_/status/1018631427930243073
                        https://twitter.com/k_r_r_l_l_/status/1016796939617095681 https://twitter.com/k_r_r_l_l_/status/1016439389348552705 https://twitter.com/k_r_r_l_l_/status/1014987258586226689 https://twitter.com/k_r_r_l_l_/status/1012675391385812993
                        https://twitter.com/k_r_r_l_l_/status/1012088341632724992 https://twitter.com/k_r_r_l_l_/status/1011361066469638144 https://twitter.com/k_r_r_l_l_/status/1011017732567924736 https://twitter.com/k_r_r_l_l_/status/1009911549283012608
                        https://twitter.com/k_r_r_l_l_/status/1008108304013258752 https://twitter.com/k_r_r_l_l_/status/1006287622027730950 https://twitter.com/k_r_r_l_l_/status/1005208076989927425 https://twitter.com/k_r_r_l_l_/status/1003750906188390401
                        https://twitter.com/k_r_r_l_l_/status/1003388558655217665 https://twitter.com/k_r_r_l_l_/status/1002494988607819776 https://twitter.com/k_r_r_l_l_/status/999409895790202881 https://twitter.com/k_r_r_l_l_/status/997315913656418305
                        https://twitter.com/k_r_r_l_l_/status/995775759049355264 https://twitter.com/k_r_r_l_l_/status/992162044462809090 https://twitter.com/k_r_r_l_l_/status/991423104218902529 https://twitter.com/k_r_r_l_l_/status/987083406159691776
                        https://twitter.com/k_r_r_l_l_/status/986356345883377665 https://twitter.com/k_r_r_l_l_/status/985993890627960840 https://twitter.com/k_r_r_l_l_/status/983457578956058624 https://twitter.com/k_r_r_l_l_/status/981645266477436928
                        https://twitter.com/k_r_r_l_l_/status/979501914307010560 https://twitter.com/k_r_r_l_l_/status/978962582999506945 https://twitter.com/k_r_r_l_l_/status/977744361512361984 https://twitter.com/k_r_r_l_l_/status/977304597483044864
                        https://twitter.com/k_r_r_l_l_/status/972953386311081984 https://twitter.com/k_r_r_l_l_/status/972593240594563072 https://twitter.com/k_r_r_l_l_/status/970411270875705344 https://twitter.com/k_r_r_l_l_/status/970080178813640704
                     ).freeze
        response.reply(reply_list.sample)
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
        suddenly_word = "```\n＿#{ '人' * (len + 1) }＿\n" +
                        "＞　#{word}　＜\n" +
                        "￣#{ 'Ｙ^' * (len * 4 / 5) }Ｙ￣\n```"
        response.reply(suddenly_word)
      end

      route(/[ねよな]+(ー$|～$)/, :consent)
      def consent(response)
        reply_list = %w(わかる それな は～いわかりま～す わかるわ～ わかる、本質からわかる。
          わかってしまったのだ… そうだよね～ 直感でわかったけど、じっくり考えて深く理解した 
          ん～！まさかそう思ってるひとがまゆしぃ以外にもいたとは！ かなりわかる わかった！一番わかった！
          さわやかなわかり わかるという感じか 軽やかなわかり げにげに 自動的にわかった まさにそれ
          はいまゆしぃわかるわかる わかる～わかるわ～～～ いやでもわかってしまう ✌わかる✌
          わかる、グイグイ来る。 そう それ言おうと思ってた わかる気がする うん それを求めてた 全まゆしぃがわかる
          ですよね！ ・・・うん それがわかるんだな～ （笑） わからんでもない それいい、心にくる 
          それはわからない 言いすぎ言いすぎ(笑) わかりすぎてしびれる わかるよォ
          わかりにく…わかるけどさ…… えっホントに さいですか わかるぞ……！！
          みんなもわかると思う わかりすぎて声も出ない 逆にね まってまってちょっとついていけてない その、なんというか…わかる…
          知るか～～～～～っ！！ すっっっごいわかる たまにある わかるわかるわかる～～ ずばり言うけれど、わかる。
          道理は正しいけど感情的には許せないみたいなね、わかる。 とってもよくわかります 
          それめっちゃいい よい あー、あるある 君の気持ちもわからんではないけど、私は相手側の味方だね。その場合。 
          そうかな わかるといえばわかる、わからないといえばわかる。 ごっつわかる わかると言っていい 
          いま名言が来ました…！ それ本に書いてたよね、本に書いてたことそのまま言ったよね 
          またその話か、わかってるって それはもういちいちわかるという必要もない 
          反対意見も多いと思うけど、わたしはわかる。キミ側の立場をとらせてもらう。 おおむねわかる
          理解できます ア～～～それはしかたないよね だよね、そうなるよね～ 逆にそれすごいと思う ちょ
        ).freeze
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
