express = require 'express'

config = require '../config.json'
site = require '../site/site'

app = express()

app.use '/', site

app.listen config.port, config.host, ->
	unless config.host
		console.log "Listening on *:#{config.port}"
	else
		console.log "Listening on #{config.host}:#{config.port}"
