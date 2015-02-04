express = require 'express'

config = require '../config.json'

site = express()

site.get '/', (req, res) ->
	res.send 'hello there, i am site'

module.exports = site
