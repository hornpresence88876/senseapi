# SmartThings Data Collection Script

## Introduction

This is an extremely rudimentary hack to poll SmartThings via the RESTful API and store the data in a local MySQL database for reporting purposes.

## Getting Started

1. `bundle update`
2. `cp config.yml.example config.yml`
3. `bundle exec ruby poll_sensors.rb`

## More Information

You will need to get your api key and token from SmartThings.

* [Get OAuth2 Authorization Code](https://community.smartthings.com/t/scheduler-and-polling-quits-after-some-minutes-hours-or-days/16997/32)

### Configuration

Setup your configuration file using the config.yml.example as the template.

```
cp config.yml.example config.yml
```

Then update the configuration for your specific environment.

Note: Currently only MySQL is tested. Using MariaDB 10.1.

## TODO

* Build in OAUTH2 for easier token acquisition
