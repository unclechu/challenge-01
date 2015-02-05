mongoose = require 'mongoose'

config = require './config'
port = if config.mongo.port? then ":#{config.mongo.port}" else ''

socketURI = "mongodb://#{config.mongo.host}#{port}/#{config.mongo.database}"

console.log "Mongo URI: '#{socketURI}'"
conn = mongoose.connect socketURI

module.exports = conn
