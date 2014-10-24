require 'open-uri'
require 'nokogiri'
require 'rubygems'
require 'mechanize'
# Class that can be used to grab data from website(http://www.hcbus.com.tw/)
class WebScraper
  # @data stores information
  attr_accessor :data
  attr_accessor :station
  attr_accessor :page
  attr_accessor :output
  attr_accessor :url

  def initialize
    @data = data
    @station = station
    @page = page
    @output = output
    @url = url
  end

  def getwebstructure(website)
    web_data = open(website)
    @data = Nokogiri.HTML(web_data)
  end

  def file_output
    selectstation
    File.write('Output.txt', @output)
    puts "\n\n\nPlease check data in Output.txt file"
  end

  def busstation
    @url = 'http://www.hcbus.com.tw/big5/service.asp'
    num, @station = 1, {}
    getwebstructure(url)
    @data.css("select[name='jumpMenu'] option").each do |x|
      @station[num] = x.text
      num += 1
    end
    @station
  end

  def selectdropdown(url, num)
    tmpkey = [], tmpvalue = []
    agent = Mechanize.new
    form = agent.get(url).forms.first
    form.field_with(name: 'jumpMenu').options[num].click
    @page  = form.submit
    content = @page.parser.xpath("//table/tr/td[@class='map-style']")
    content2 = @page.parser.xpath("//table/tr/td[@class='map-style'][1]")
    content2.each { |b| tmpkey << b.text.strip }
    content.each { |c| tmpvalue << c.text.strip }
    filehash(tmpvalue, tmpkey)
  end

  def filehash(value, key)
    value.each  do  |v|
      key.each  do  |c|
        @output << '**************************************'  if v == c
      end
      @output << v
    end
    @output << '**************************************'
  end

  def tmp_selectstation
    num, @station, @output  = 1, {}, []
    getwebstructure(url)
    @data.css("select[name='jumpMenu'] option").each do |x|
      @station[num] = x.text
      num += 1
    end
    (0...9).each do |i|
      selectdropdown(@url, i)
    end
    @output
  end
end
