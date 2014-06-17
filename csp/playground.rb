require 'twitter'
require 'joe'
require 'celluloid'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "dflgkoro0BZgn1t9ZQizwnQTS"
  config.consumer_secret     = "iYwYwZ5gwHuGjqrfvnt5a7hqIvJmXPoDaVKepNBnU7Hz200rdM"
  config.access_token        = "15236043-AdjgUZAvEfspWROcoGiALkjqhmFXAE1EYfHv60040"
  config.access_token_secret = "jhROvQNylD0hkJDKJTY11psULosBCIlDvOrUXG23Q7YtF"
end

client.search("worldcup", lang: "en", result_type: "recent").take(10).each do |t|
  puts t.text
end
