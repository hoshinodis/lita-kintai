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

      route(/^おは$|^がんばるぞい|^しごはじ|((^お仕事|^おしごと)+(はじめ|始め))/, :start_work)
      def start_work(response)
        time = Time.now

        # 家に帰った者にのみ出社は訪れる
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        unless result.nil?
          return response.reply('家に帰らないと出社はできないんだよ') if result['start_at'] == result['end_at']
        end

        # 出社出社
        insert_query = "insert into #{TABLE_NAME} (id, start_at, end_at) values('#{response.user.id}', '#{datetime(time)}', '#{datetime(time)}')"
        response.reply(insert_query)
        client.query(insert_query)
        reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に出社しました"
        response.reply(reply)
      end

      route(/^おつ$|^がんばったぞい|^しごとわた|((^お仕事|^おしごと)+おしまい)/, :end_work)
      def end_work(response)
        time = Time.now

        # 最新のスタートとエンドが同じだったら更新する。時間も計算する
        # todo:割り増し時間も計算したい
        client = connect
        select_query = "select * from #{TABLE_NAME} where id = '#{response.user.id}' order by start_at desc"
        result = client.query(select_query).first
        unless result.nil?
          update_query = "update #{TABLE_NAME} set end_at = '#{datetime(time)}', syussya_time = #{((time - result['start_at'])/60).to_i} where id = '#{response.user.id}' and end_at = '#{datetime(result['start_at'])}'"
          client.query(update_query) if result['start_at'] == result['end_at']
          reply = "#{response.user.name}さんが#{time.strftime("%H時%M分")}に退社しました"
          return response.reply(reply)
        end

        response.reply('あれー？出社してないみたいだよ')
      end

      # todo:リモスタ start_at使う,前日リモート対応もある
      # todo:リモおわ リモートは1日に複数回訪れる

      route(/^今月+(しごと|仕事)+した+(\?|？)$/, :monthly_work)
      def monthly_work(response)
        time = Time.now
        start_at = datetime(Time.new(time.year, time.month, 1))
        end_at = datetime(Time.new(time.year, time.month + 1, 1))
        client = connect
        select_query = "select sum(remote_time) remote, sum(syussya_time) syussya, sum(warimashi_time) warimashi from #{TABLE_NAME} where id = '#{response.user.id}' and start_at between '#{start_at}' and '#{end_at}'"
        result = client.query(select_query).first
        reply = "#{response.user.name}さんは、今月 #{format('%.1f', result['syussya'].to_f / 60.0)} 時間働きました（内 リモート:#{format('%.1f', result['remote'].to_f / 60.0)} 時間, 割増:#{format('%.1f', result['warimashi'].to_f / 60.0)} 時間）。"
        response.reply(reply)
      end

      route(/^先月+(しごと|仕事)+した+(\?|？)$/, :last_monthly_work)
      def last_monthly_work(response)
        time = Time.now
        start_at = datetime(Time.new(time.year, time.month - 1, 1))
        end_at = datetime(Time.new(time.year, time.month, 1))
        client = connect
        select_query = "select sum(remote_time) remote, sum(syussya_time) syussya, sum(warimashi_time) warimashi from #{TABLE_NAME} where id = '#{response.user.id}' and start_at between '#{start_at}' and '#{end_at}'"
        result = client.query(select_query).first
        reply = "#{response.user.name}さんは、先月 #{format('%.1f', result['syussya'].to_f / 60.0)} 時間働きました（内 リモート:#{format('%.1f', result['remote'].to_f / 60.0)} 時間, 割増:#{format('%.1f', result['warimashi'].to_f / 60.0)} 時間）。"
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
