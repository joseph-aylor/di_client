class Station
  attr_accessor :url
  attr_accessor :title
  def initialize(url, title)
    @url = url
    @readable_title = title
    @title = title_format(title)
  end

  def create_alias
    puts "alias #{@title}=\"mplayer '#{@url}'\""
  end

  def create_pls
    File.open("#{title}.pls", 'w') do |f|
      f.write(pls_file_text)
      f.close
    end
  end

  private

  def pls_file_text
    pls_template = "[playlist]\n"
    pls_template += "NumberOfEntries=1\n"
    pls_template += "File1=#{@url}\n"
    pls_template += "Title1=Digitally Imported - #{@readable_title}\n"
    pls_template += "Length1=-1\n"
    pls_template += 'Version=2'
  end

  def title_format(title)
    title
      .downcase
      .gsub(/digitally imported - /, '')
      .gsub(/\s+/, '_')
  end
end
