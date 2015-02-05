local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

class MainPageHandler extends RequestHandler
	template: 'catalog-categories'
	constructor: ->
		super
		@data.pageTitle = local.sections.catalogCategories
	get: (req, res) =>
		data = @getChargedData req
		res.render @template, data

module.exports = {MainPageHandler}
