local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

class SearchPageHandler extends RequestHandler
	template: 'catalog-search'
	constructor: ->
		super
		@data.pageTitle = local.sections.search
	get: (req, res) =>
		@getChargedData req, (err, data) =>
			if err
				console.error 'Cannot get charged data:\n', err
				return @serverFail req, res
			res.render @template, data

module.exports = {SearchPageHandler}
