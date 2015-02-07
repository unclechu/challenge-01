local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

class MainPageHandler extends RequestHandler
	template: 'pages/catalog/main'
	constructor: ->
		super
		@data.pageTitle = local.sections.catalogCategories
	requiredData: ['categoriesList']
	get: (req, res) =>
		@getChargedData req, (err, data) =>
			if err
				console.error 'Cannot get charged data:\n', err
				return @serverFail req, res
			res.render @template, data

module.exports = {MainPageHandler}
