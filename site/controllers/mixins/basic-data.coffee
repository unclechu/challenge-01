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
				jump1 = =>
					if 'elementsList' in @requiredData
						@getChargedCatalogElements req, (err, list) =>
							return cb err if err
							data.catalogElements = list
							jump2()
					else
						jump2()
				jump2 = =>
					cb null, data
				if 'categoriesList' in @requiredData
					@getChargedCatalogCategories req, (err, list) =>
						return cb err if err
						data.catalogCategories = list
						jump1()
				else
					jump1()

module.exports = {BasicDataMixin}
