module Lita
  module Handlers
    class Kintai < Handler
      TABLE_NAME = 'kintai'

      def connect
        Mysql2::Client.new(:host => 'localhost', :user => 'root', :password => 'root', :database => 'lita_kintai')
      end

      def datetime(time)
        time.strftime('%F %T')
      end

      route(/\Aおは$|\Aがんばるぞい|\Aしごはじ|((\Aお仕事|\Aおしごと)+(はじめ|始め))/, :start_work)
      def start_work(response)
        time = Time.now

        # 家に帰った者にのみ出社は訪れる
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        unless result.nil?
          return response.reply('家に帰らないと出社はできないんだよ') if result['start_at'] == result['end_at']
        end
        
        if !result.nil? && !result['remote_start_at'].nil?
          return response.reply('リモートが終わらないと出社はできないんだよ') if result['remote_start_at'] == result['remote_end_at']
        end

        # 出社出社
        insert_query = "insert into #{TABLE_NAME} (id, name, start_at, end_at) values('#{response.user.id}', '#{response.user.name}', '#{datetime(time)}', '#{datetime(time)}')"
        client.query(insert_query)
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(reply)
      end

      route(/\Aおつ$|\Aがんばったぞい|\Aしごとわた|((\Aお仕事|\Aおしごと)+おしまい)/, :end_work)
      def end_work(response)
        time = Time.now

        # 最新のスタートとエンドが同じだったら更新する。時間も計算する
        # todo:割り増し時間も計算したい
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        if result['remote_start_at'].nil? && result['start_at'] == result['end_at']
          syussya_time = ((time - result['start_at'])/60).to_i
          syussya_time = syussya_time - 60 if syussya_time >= (8 * 60)
          update_query = "update #{TABLE_NAME} set end_at = '#{datetime(time)}', syussya_time = #{syussya_time} where id = '#{response.user.id}' and end_at = '#{datetime(result['start_at'])}'"
          client.query(update_query) if result['start_at'] == result['end_at']
          reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退勤しました"
          return response.reply(reply)
        end

        response.reply('あれー？出社してないみたいだよ')
      end

      route(/\Aリモおは$|\Aリモートがんばるぞい|\Aリモはじ|((\Aリモート|^りもーと)+(はじめ|始め))/, :start_remote_work)
      def start_remote_work(response)
        time = Time.now

        # 家に帰った者にのみリモートは訪れる
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        unless result.nil?
          return response.reply('家に帰らないとリモートはできないんだよ') if result['start_at'] == result['end_at']
        end

        # 出社出社
        insert_query = "insert into #{TABLE_NAME} (id, name, start_at, end_at, remote_start_at, remote_end_at) values('#{response.user.id}', '#{response.user.name}', '#{datetime(time)}', '#{datetime(time)}', '#{datetime(time)}', '#{datetime(time)}')"
        client.query(insert_query)
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}にリモート開始しました"
        response.reply(reply)
      end

      # todo:リモおわ リモートは1日に複数回訪れる
      route(/\Aリモおつ$|\Aリモートがんばったぞい|\Aリモわた|\Aリモおわ|((\Aリモート|^りもーと)+おしまい)/, :end_remote_work)
      def end_remote_work(response)
        time = Time.now

        # 最新のスタートとエンドが同じだったら更新する。時間も計算する
        # todo:割り増し時間も計算したい
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        if !result['remote_start_at'].nil? && result['remote_start_at'] == result['remote_end_at']
          syussya_time = ((time - result['start_at'])/60).to_i
          syussya_time = syussya_time - 60 if syussya_time >= (8 * 60)
          update_query = "update #{TABLE_NAME} set end_at = '#{datetime(time)}', remote_end_at = '#{datetime(time)}', syussya_time = #{syussya_time}, remote_time = #{syussya_time} where id = '#{response.user.id}' and end_at = '#{datetime(result['start_at'])}'"
          client.query(update_query) if result['remote_start_at'] == result['remote_end_at']
          reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}にリモート終了しました"
          return response.reply(reply)
        end

        response.reply('あれー？リモートしてないみたいだよ')
      end

      def next_month(time)
        if time.month == 12
          Time.new(time.year + 1, 1, 1)
        else
          Time.new(time.year, time.month + 1, 1)
        end
      end

      def prev_month(time)
        if time.month == 1
          Time.new(time.year - 1, 12, 1)
        else
          Time.new(time.year, time.month - 1, 1)
        end
      end

      route(/^今月+(しごと|仕事)+した+(\?|？)$/, :monthly_work)
      def monthly_work(response)
        time = Time.now
        start_at = datetime(Time.new(time.year, time.month, 1))
        end_at = datetime(next_month(time))
        client = connect
        select_query = "select sum(remote_time) remote, sum(syussya_time) syussya, sum(warimashi_time) warimashi from #{TABLE_NAME} where id = '#{response.user.id}' and start_at between '#{start_at}' and '#{end_at}'"
        result = client.query(select_query).first
        reply = "#{response.user.name}さんは、今月 #{format('%.1f', result['syussya'].to_f / 60.0)} 時間働きました（内 リモート:#{format('%.1f', result['remote'].to_f / 60.0)} 時間, 割増:#{format('%.1f', result['warimashi'].to_f / 60.0)} 時間）。"
        response.reply(reply)
      end

      route(/^先月+(しごと|仕事)+した+(\?|？)$/, :last_monthly_work)
      def last_monthly_work(response)
        time = Time.now
        start_at = datetime(prev_month(time))
        end_at = datetime(Time.new(time.year, time.month, 1))
        client = connect
        select_query = "select sum(remote_time) remote, sum(syussya_time) syussya, sum(warimashi_time) warimashi from #{TABLE_NAME} where id = '#{response.user.id}' and start_at between '#{start_at}' and '#{end_at}'"
        result = client.query(select_query).first
        reply = "#{response.user.name}さんは、先月 #{format('%.1f', result['syussya'].to_f / 60.0)} 時間働きました（内 リモート:#{format('%.1f', result['remote'].to_f / 60.0)} 時間, 割増:#{format('%.1f', result['warimashi'].to_f / 60.0)} 時間）。"
        response.reply(reply)
      end
      
      route(/^今日+(は誰|はだれ|誰|だれ)+(いる|居る)+(\?|？)$/, :whos_work_today)
      def whos_work_today(response)
        time = Time.now
        start_at = datetime(Time.new(time.year, time.month, time.day))
        client = connect
        # name属性持たせなかったの失敗したあ
        select_query = "select name from #{TABLE_NAME} where start_at between '#{start_at}' and '#{time}' and end_at = start_at and remote_start_at is null group by name"
        results = client.query(select_query)
        reply = "=== 出社 ===\n"
        results.each do |row|
          row.each do |key, value|
            reply = reply + "#{value} \n"
          end
        end
        response.reply(reply)
        
        select_query = "select name from #{TABLE_NAME} where remote_start_at between '#{start_at}' and '#{time}' and remote_end_at = remote_start_at group by name"
        results = client.query(select_query)
        reply = "=== リモート ===\n"
        results.each do |row|
          row.each do |key, value|
            reply = reply + "#{value} \n"
          end
        end
        response.reply(reply)
      end

      route(/(しごと|仕事).*ない$/, :grieve_work)
      def grieve_work(response)
        time = Time.now
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に嘆きました"
        response.reply(reply)
      end

    end

    Lita.register_handler(Kintai)
  end
end
