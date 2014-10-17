# User Interface (takes user input from the user at the command line)

require_relative 'Scraper'

usage = "\n Usage : executable [number] .\n\n Number 1 : Hsinchu bus\' stations. \n Number 2 : Get bus stataion names.\n Number 3 : Get bus stataion information in detail.\n Number 4 : Get file (bus stataion information)bus."
fail ArgumentError, usage if ARGV.count != 1

number = ARGV[0]


scmachine = WebScraper.new

#while(number)
case number
  when '1'
    scmachine.getwebstructure('http://www.hcbus.com.tw')
  when '2'
    scmachine.busstation
  when '3'
    scmachine.selectstation
  when '4'
    scmachine.file_output
  
  else
    puts '(1~4) Error input : you key in No ' << number.to_s
end
