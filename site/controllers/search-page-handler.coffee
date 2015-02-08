local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

class SearchPageHandler extends RequestHandler
	template: 'pages/catalog/search'
	constructor: ->
		super
		@data.pageTitle = local.sections.search
	get: (req, res) =>
		@getChargedData req, (err, data) =>
			if err
				console.error 'Cannot get charged data:\n', err
				return @serverFail req, res

			data.searchQuery = null
			data.searchQuery = req.query.q if req.query.q?

			# if not search
			return res.render @template, data unless req.query.q?

			req.catalogElementsBySearch = true
			@getChargedCatalogElements req, (err, list) =>
				if err
					console.error 'Cannot get catalog elements by search:\n', err
					return @serverFail req, res
				data.catalogElements = list
				@getCatalogElementsPagination req, (err, list) =>
					if err
						console.error 'Cannot get catalog elements pagination by search:\n', err
						return @serverFail req, res
					data.catalogElementsPagination = list
					res.render @template, data

module.exports = {SearchPageHandler}
