require 'busgogo'
usage = []
usage << "\n Usage : executable [number] .\n"
usage << "\nNumber 1 : Hsinchu bus\' stations."
usage << "\n Number 2 : Get bus stataion names."
usage << "\n Number 3 : Get bus stataion information in detail."
usage << "\n Number 4 : Get file (bus stataion information)bus."
fail ArgumentError, usage if ARGV.count != 1
number = ARGV[0]
scmachine = WebScraper.new
structure_output = scmachine.getwebstructure('http://www.hcbus.com.tw')
bus_station = scmachine.busstation
information = scmachine.tmp_selectstation
case number
when '1'
  File.write('Structure.txt', structure_output)
when '2'
  bus_station.each { |value| puts value }
when '3'
  puts information
when '4'
  File.write('Output.txt', information)
  puts 'Please check data in Output.txt file'
else
  puts '(1~4) Error input : you key in No ' << number.to_s
end
