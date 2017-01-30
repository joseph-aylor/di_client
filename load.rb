require 'net/http'
key = '918bde2e7146343d7948870c'
url = "http://listen.di.fm/premium/favorites.pls?#{key}"

class Station
  attr_accessor :url
  attr_accessor :title
  def initialize(url, title)
    @url = url
    @readable_title = title
    @title = title_format(title)
    create_alias
    create_pls
  end

  private

  def create_alias
    puts "alias #{@title}=\"mplayer '#{@url}'\""
  end

  def create_pls
    File.open("#{title}.pls", "w") do |f|
      f.write(pls_file_text)
      f.close
    end
  end

  def pls_file_text
    pls_template = "[playlist]\n"
    pls_template += "NumberOfEntries=1\n"
    pls_template += "File1=#{@url}\n"
    pls_template += "Title1=Digitally Imported - #{@readable_title}\n"
    pls_template += "Length1=-1\n"
    pls_template += "Version=2"
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
