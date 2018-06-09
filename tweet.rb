require 'twitter'
require 'anemone'
require 'nokogiri'
require 'kconv'

class Tweet
    
    # 電車の遅延情報をクロールし、twitterに流すbotを作成する
    # botのタイミングはherokuで制御する
    
    # 初期化
    def initialize
        urls = []
        urls.push("クロール先のURL")
        
        
        Anemone.crawl(urls, :depth_limit => 0) do |anemone|
            anemone.on_every_page do |page|
                # 文字コードをUTF8に変換したうえで、Nokogiriをパース
                doc = Nokogiri::HTML.parse(page.body.toutf8)
                # クロールする部分のXpathを指定
                @train = doc.xpath("/html/body/hoge/hoge").text
                @infomation = doc.xpath("/html/body/hoge/hoge").text
                
            end
            
            @text = ""
            
            # 各種環境変数の設定
            @client = Twitter::REST::Client.new do |config|
                config.consumer_key        = "hoge"
                config.consumer_secret     = "hoge"
                config.access_token        = "hoge"
                config.access_token_secret = "hoge"
            end
        end
        
        # 文言の作成
        def random_tweet
            @text = @train + @infomation
            tweet = @text
            update(tweet)
        end
        
        # アカウントと連携
        def update(tweet)
            begin
                @client.update(tweet)
                rescue => e
                nil #TODO
            end
        end
        
    end
    
    # random_tweetを実行する
    if __FILE__ == $0
    Tweet.new.random_tweet
end
end
