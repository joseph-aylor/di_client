require 'net/http'
require './station'

class Loader
  def initialize (url)
    @url = url
    load
  end

  def create_list(stations)
    station_list = stations.map(&:title).join("\n")
    puts "alias dils=\"echo '#{station_list}'\""
  end

  def load
    uri = URI(@url)
    pls = Net::HTTP.get(uri)

    stations = []

    pls[/Version=[0-9]/] = ''
    pls = pls.gsub(/\[playlist\]\nNumberOfEntries=[0-9]+\n/, '')
    pls = pls.gsub(/File[0-9]+=/, '')
    pls = pls.gsub(/Length[0-9]+=-1\n/, '')
    pls = pls.gsub(/Title[0-9]+=/, '')
    pls.split("\n").each_slice(2) do |u, t|
      stations.push(Station.new(u, t))
    end

    stations.each do |s|
      s.create_pls
      s.create_alias
    end
    create_list(stations)
  end
end

key = '918bde2e7146343d7948870c'
url = "http://listen.di.fm/premium/favorites.pls?#{key}"

Loader.new(url)

# system("mplayer \"#{stations.last.url}\"")
