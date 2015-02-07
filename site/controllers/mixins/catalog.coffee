{CatalogCategoryModel} = require '../../models/catalog'

class CatalogCategoriesMixin
	getChargedCatalogCategories: (req, cb) ->
		return cb new Error 'No helpers for getChargedCatalogCategories()' unless @helpers?
		menu = []

		CatalogCategoryModel.find (err, list) =>
			return cb err if err

			for item in list
				menu.push do (obj={}) =>
					obj[key] = item[key]\
						for key of item when key in ['_id', 'name']
					link = "/section_#{obj._id}.html"
					obj.active = if link.indexOf(req.url) is 0 and req.url isnt '/' then true else false
					obj.current = if obj.active and link is req.url then true else false
					obj.link = @helpers.relUrl req.baseUrl, link
					obj

			cb null, menu

module.exports = {CatalogCategoriesMixin}
