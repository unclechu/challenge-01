local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

class SearchPageHandler extends RequestHandler
	template: 'catalog-search'
	constructor: ->
		super
		@data.pageTitle = local.sections.search
	get: (req, res) =>
		data = @getChargedData req
		res.render @template, data

module.exports = {SearchPageHandler}
