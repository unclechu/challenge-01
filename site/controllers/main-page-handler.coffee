RequestHandler = require('./request-handler').RequestHandler

class MainPageHandler extends RequestHandler
	template: 'catalog-page'
	constructor: ->
		super
		@data.pageTitle = @data.local.pageTitles.catalogList
	get: (req, res) =>
		data = {}
		data[key] = @data[key] for key of @data
		data[key] = @helpers[key] for key of @helpers
		res.render @template, data

module.exports = {MainPageHandler}
