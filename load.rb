require 'net/http'
key = '918bde2e7146343d7948870c'
url = "http://listen.di.fm/premium/favorites.pls?#{key}"

class Station
  attr_accessor :url
  attr_accessor :title
  def initialize(url, title)
    @url = url
    @title = title_format(title)
    create_alias
  end

  private

  def create_alias
    puts "alias #{@title}=\"mplayer '#{@url}'\""
  end

  def title_format(title)
    title
      .downcase
      .gsub(/digitally imported - /, '')
      .gsub(/\s+/, '_')
  end
end

def create_list(stations)
  station_list = stations.map(&:title).join("\n")
  puts "alias dils=\"echo '#{station_list}'\""
end

uri = URI(url)
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

create_list(stations)

# system("mplayer \"#{stations.last.url}\"")
