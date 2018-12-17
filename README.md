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

## Run the tests

```
rake db:test:prepare
RAILS_ENV=test rake db:fixtures:load
rake
```
(Models and Integration (FE) tests have been implemented.)

## Approach
The Search Demo App is a Vanilla Rails/React App running on Sqlite3
database. The home screen implements a simple search that searches the local
database by ASIN or title. When there are no local results, and the search
fits the ASIN format (length 10, alphanumeric) the page at URL
`https://www.amazon.com/dp/<asin>` is retrieved, parsed, and stored in the
database.
Client side (browser side) screen scraping was considered as it offloads the
URL retrieving and parsing from the server. [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
mechanism prevents the client side implementation (Fetch/Ajax) and the server side
screen scraping implementation was selected.

### Amazon::Lookup, Amazon::ProductParser
The central part of the demo are parser classes (app/models/amazon) and the
corresponding tests (test/models/amazon) and ASIN fixtures
(test/fixtures/files). The parser produces the `Amazon::Product` header and the
`Amazon::ProductDetails` details. There are several `Amazon::ProductDetails`
parsing strategies implemented corresponding the page layouts encountered. The
*test/fixtures/files* contains downloaded product pages exercised in the
tests. 

#### Adding new test cases (new ASIN layouts)
To add test cases for a new ASIN (not covered by current parser variants) :
- download the product page into the test/fixtures/files directory, for
  example:
  ```
  curl --compressed -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36' https://www.amazon.com/dp/B00HXGSBXC > test/fixtures/files/B00HXGSBXC
  ```
 - add corresponding test(s) to the test/models/amazon/amazon_parser_test.rb 
 - implement parser changes (models/amazon/*_parser.rb)

## Challenges
The scraped data requires extensive testing and validation to develop
understanding and confidence in parsed records as there is
no formal page format specification and Amazon has many product page layouts.

## Considerations
- Sqlite3 database was selected for demo purpose only, eventual _production_ might
  consider database such as MySQL/Postgres etc.
- User/Authentication / Permissions: is a placeholder only; eventual
 _production_  application would implement an actual authentication /
 authorization, sign-up. 
- In addition a _production_ version of the application requires defining the deployment
  model/process (containers, simple Capistrano deployment model or else)
  monitoring (Pingdom, log events - exceptions, user support etc)
- Capybara FE testing should be added to complete the FE coverage for the
  Javascript FE parts.

## Scaling
If scraping Amazon on a large scale (millions of users), may consider
horizontal scaling, hosting the app  in the cloud and load balancers.
Consider scaling with async, evented frameworks, message brokers etc 
(Redis, Rabbit MQ, AWS Lambda etc) where it fits. 
Also consider sharding the database and introduce read-only replicas.
In addition, Amazon may may be throttling screen scraping, and the specific 
techniques may be needed such as : *User Agent* rotation, IP address rotation. 
