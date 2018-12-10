# Amazon ASIN Search Demo App

## Run it locally

```
$ bundle install
$ yarn install (or npm install)
$ rake db:setup
$ rails s
```
Try searching for terms : *lettuce*, *candor*, *raid*; try searching for an
Amazon ASIN.

##Approach
The Search Demo App is a Vanilla Rails/React App running on Sqlite3
database. The home screen implements a simple search that searches the local
database by ASIN or title. When there are no local results, and the search
fits the ASIN format (length 10, alphanumeric) the page at URL
https://www.amazon.com/dp/<asin> is retrieved, parsed and stored in the database.
### Amazon::Lookup, Amazon::ProductParser
The central part of the demo are parser classes (app/models/amazon) and the
corresponding tests (test/models/amazon) and fixtures
(test/fixtures/files). The parsers produces the *Amazon::Product* header and the
*Amazon::ProductDetails* details. There are several *Amazon::ProductDetails*
parsing strategies implemented corresponding the page layouts enountered. The
*test/fixtures/files* contains downloaded product pages excercised in the tests. 

##Challenges
The scraped data requires extensive testing and validation to develop
understanding and confindence in parsed records as there is
no formal page format specification and Amazon has many product page layouts.

##Scaling
If scraping Amazon on a large scale (millions of product pages a day), may
need a lot of servers to get the data within a reasonable time. Consider
hosting the app  in the cloud, consider scaling with async, evented
frameworks, message brokers etc (Redis, Rabbit MQ, AWS Lambda
etc). Also consider sharding the database and introduce read-only
replicas. In addition, Amazon may may be throttling scraping, and the
specific techniques may be needed such as : *User Agent* rotation, IP address rotation. 
