config = require '../../utils/config'
local = require '../../utils/localization'

{BasicDataMixin} = require './mixins/basic-data'

class RequestHandler extends BasicDataMixin
	constructor: ->
		@data =
			lang: config.lang
			local: local
		super
	serverFail: (req, res) ->
		res.status(500).end '500 Internal Server Error'
	get: (req, res) =>
		res.status(405).end()
	post: (req, res) =>
		res.status(405).end()

module.exports = {RequestHandler}
