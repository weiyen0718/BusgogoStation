##BusGoGo

###Description ( Hsinzhu Bus Website )

We use *Hsinzhu Bus Website* because we often take hsinzhu bus to somewhere.
Everytime we are heading for somewhere, we go to their website(http://www.hcbus.com.tw/) to get information about their service station, time, and route.
Therefore, we think it will be convenience for us to use web scraper to get specific information we want.
This website dosen't provide API and need not log in.
Take the link() to use our service.

### Sevice
1)Home
2)Station
3)Tutorial

#### Station
Type area num,service will return all stop name and address in that area.

#### Tutorial
Type area num,area name,address
if not found,restart the page
if found,it will return the result


### API Usages
API link :https://github.com/weiyen0718/busgogo_dynamo
There are APIs you can use
+Bus stop address information:
   https://busgogo-dynamo.herokuapp.com/api/v2/station/(:num).json 
   
  You have three choices to replace the ```(num)``` part.
  1. use ```1``` to get the all stop name and address in 新竹地區.
  2. use ```2``` to get the all stop name and address in 竹東地區.

  until 10
  and you can get all stop name and address in some area
  
###Other API
 GET '/api/v2/station/:num.json' do
 
 POST '/api/v2/tutorials' do
 
 GET '/api/v2/tutorials/:id' do
 
 DELETE '/api/v2/tutorials/:id' do
 

###Authors

Yen Wei ,Wu ChiaChun




