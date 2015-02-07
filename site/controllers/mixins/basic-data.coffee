virtualClass = require '../../../utils/virtual-class'

{HelpersMixin} = require './helpers'
{MenuDataMixin} = require './menu'
{CatalogCategoriesMixin} = require './catalog'

class BasicDataMixin extends virtualClass HelpersMixin, MenuDataMixin, CatalogCategoriesMixin
	requiredData: []
	getChargedData: (req, cb) ->
		data = {}
		@getChargedHelpers req, (err, helpers) =>
			return cb err if err
			data[key] = @data[key] for key of @data
			data[key] = helpers[key] for key of helpers
			@getChargedMenu req, (err, menu) =>
				return cb err if err
				data.menu = menu
				if 'categoriesList' in @requiredData
					@getChargedCatalogCategories req, (err, list) =>
						return cb err if err
						data.catalogCategories = list
						cb null, data
				else
					cb null, data

module.exports = {BasicDataMixin}
