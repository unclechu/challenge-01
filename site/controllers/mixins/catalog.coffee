{CatalogCategoryModel, CatalogElementModel} = require '../../models/catalog'

class CatalogCategoriesMixin
	getChargedCatalogCategories: (req, cb) ->
		return cb new Error 'No helpers for getChargedCatalogCategories()' unless @helpers?
		menu = []

		CatalogCategoryModel.find (err, list) =>
			return cb err if err

			for item in list then do (item, obj={}) =>
				obj[key] = item[key]\
					for key of item when key in ['_id', 'name']
				link = "/section_#{obj._id}.html"
				obj.active = if link.indexOf(req.url) is 0 and req.url isnt '/' then true else false
				obj.current = if obj.active and link is req.url then true else false
				obj.link = @helpers.relUrl req.baseUrl, link
				menu.push obj

			cb null, menu

	getChargedCatalogElements: (req, cb) ->
		return cb new Error 'No helpers for getChargedCatalogCategories()' unless @helpers?
		menu = []

		CatalogElementModel.find categories: @categoryId, (err, list) =>
			return cb err if err

			start = ->
				getElementsLoop()
			complete = ->
				cb null, menu

			getElementsLoop = =>
				return complete() if list.length <= 0
				do (item=list.shift(), obj={}, start=null, complete=null) =>
					obj[key] = item[key]\
						for key of item when key in ['_id', 'name', 'price']
					obj.price = obj.price.toFixed 2
					obj.categories = []
					obj.picture = @helpers.uploadedUrl item.image

					start = ->
						getCategoriesLoop()
					complete = ->
						menu.push obj
						getElementsLoop()

					getCategoriesLoop = =>
						return getMerchantsLoop() if item.categories.length <= 0
						CatalogCategoryModel.findOne \
						_id: item.categories.shift(), (err, category) ->
							return cb err if err
							obj.categories.push do (obj={}) ->
								obj[key] = category[key] for key of category when key in ['_id', 'name']
								obj
							getCategoriesLoop()

					getMerchantsLoop = =>
						complete()

					start()

			start()

module.exports = {CatalogCategoriesMixin}
