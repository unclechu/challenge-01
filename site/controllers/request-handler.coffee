config = require '../../utils/config'
local = require '../../utils/localization'
virtualClass = require '../../utils/virtual-class'

{MenuDataMixin} = require './mixins/menu'
{HelpersMixin} = require './mixins/helpers'
{BasicDataMixin} = require './mixins/basic-data'

class RequestHandler extends virtualClass HelpersMixin, MenuDataMixin, BasicDataMixin
	constructor: ->
		@data =
			lang: config.lang
			local: local
		super
	get: (req, res) =>
		res.status(405).end()
	post: (req, res) =>
		res.status(405).end()

module.exports = {RequestHandler}
