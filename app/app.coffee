path = require 'path'
express = require 'express'

config = require '../utils/config'
site = require '../site/site'

app = express()

app.use '/', site

app.use '/static', express.static path.join process.cwd(), config.paths.static

app.listen config.port, config.host, ->
	unless config.host
		console.log "Listening on *:#{config.port}"
	else
		console.log "Listening on #{config.host}:#{config.port}"
