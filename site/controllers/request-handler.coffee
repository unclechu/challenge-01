path = require 'path'

config = require '../../utils/config'
local = require '../../utils/localization'

class RequestHandler
	data: {}
	helpers:
		staticUrl: (relpath) -> path.join '/static/', relpath
	constructor: ->
		@data.lang = config.lang
		@data.local = local
	get: (req, res) =>
		res.status(405).end()
	post: (req, res) =>
		res.status(405).end()

module.exports = {RequestHandler}
