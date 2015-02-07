path = require 'path'
express = require 'express'
mongoose = require 'mongoose'

config = require '../utils/config'
site = require '../site/site'

app = express()

app.use '/catalog/', site

app.use '/static/', express.static path.join process.cwd(), config.paths.static
app.use '/uploaded/', express.static path.join process.cwd(), config.paths.uploaded

app.listen config.port, config.host, ->
	unless config.host
		console.log "Listening on *:#{config.port}"
	else
		console.log "Listening on #{config.host}:#{config.port}"

process.on 'exit', (code) ->
	if code isnt 0
		console.error "Exiting with code: #{code}"
	else
		console.log "Exiting with code: #{code}"
	mongoose.disconnect()
