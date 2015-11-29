#!/usr/bin/env ruby

require 'json'
require 'curl'
require 'sequel'
require 'mysql'
require 'date'
require 'yaml'

# First we must load the config
CONFIG = YAML::load_file(File.join(__dir__, 'config.yml'))

# SmartThings Configuration
ST_BASE  = "https://graph.api.smartthings.com:443/api/smartapps/installations"
ST_KEY   = CONFIG['st']['key']
ST_TOKEN = CONFIG['st']['token']
ST_URL   = "#{ST_BASE}/#{ST_KEY}"

# MySQL Information
DB_ADAPTER = CONFIG['db']['adapter']
DB_HOST    = CONFIG['db']['host']
DB_USER    = CONFIG['db']['user']
DB_PASS    = CONFIG['db']['pass']
DB_NAME    = CONFIG['db']['name']
DB_TABLE   = CONFIG['db']['table']

# Endpoints
endpoints = []

DB = Sequel.connect(:adapter => DB_ADAPTER, :user => DB_USER, :host => DB_HOST, :database => DB_NAME, :password => DB_PASS)

sensors = DB[DB_TABLE.to_sym]
@timestamp = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

endpoints = CONFIG['endpoints']

endpoints.each do |e|
  http = Curl.get("#{ST_URL}/#{e}") do |http|
    http.headers['Authorization'] = "Bearer #{ST_TOKEN}"
  end
  resp = JSON.parse(http.body_str)

	# Setup our Schema
  DB.create_table? :sensors do
    primary_key :id
    DateTime :time
    String :name
    String :value
    String :unit
    String :endpoint
  end

  # Run Through Each Response
  resp.each do |r|
    sensors.insert(:time => @timestamp, :name => r['name'], :value => r['value'], :unit => r['unit'], :endpoint => e.to_s)
  end
end

