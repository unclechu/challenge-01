{parse: urlParse} = require 'url'

config = require '../../../config'

{CatalogCategoryModel, CatalogElementModel} = require '../../models/catalog'
{MerchantModel} = require '../../models/merchant'

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
				obj.active = if req.url.indexOf(link) is 0 and req.url isnt '/' then true else false
				obj.current = if obj.active and link is req.url then true else false
				obj.link = @helpers.relUrl req.baseUrl, link
				menu.push obj

			cb null, menu

	getElements = ({req, cb, page, skip, limit}) ->
		menu = []
		CatalogElementModel.find \
		{categories: @categoryId}, null, {skip, limit}, (err, list) =>
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
					obj.categories = []
					obj.picture = @helpers.uploadedUrl item.image

					start = ->
						getCategoriesLoop()
					complete = ->
						menu.push obj
						getElementsLoop()

					getCategoriesLoop = =>
						return getMerchants() if item.categories.length <= 0
						CatalogCategoryModel.findOne \
						_id: item.categories.shift(), (err, category) ->
							return cb err if err
							obj.categories.push do (obj={}) ->
								obj[key] = category[key] for key of category when key in ['_id', 'name']
								obj
							getCategoriesLoop()

					getMerchants = =>
						MerchantModel.findOne _id: item.merchant, (err, merchant) ->
							return cb err if err
							obj.merchant = do (obj={}) ->
								obj[key] = merchant[key] for key of merchant when key in ['_id', 'name']
								obj
							complete()

					start()

			start()

	getPageInfo = (req, cb) ->
		CatalogElementModel.count {categories: @categoryId}, (err, count) =>
			return cb err if err
			page = parseInt req.query[config.catalog.elementsPaginationVar], 10
			page = 1 if isNaN page
			skip = config.catalog.elementsOnPage * (page - 1)
			limit = config.catalog.elementsOnPage
			totalPages = Math.ceil count / limit
			if page < 1 or page > totalPages
				skip = 0
				limit = 0
			cb null, {page, skip, limit, totalPages}

	getChargedCatalogElements: (req, cb) ->
		return cb new Error 'No helpers for getChargedCatalogCategories()' unless @helpers?
		getPageInfo.call @, req, (err, {page, skip, limit, totalPages}) =>
			return cb err if err
			getElements.call @, {req, cb, page, skip, limit}

	getCatalogElementsPagination: (req, cb) ->
		getPageInfo.call @, req, (err, {page, skip, limit, totalPages}) =>
			return cb err if err
			menu = []
			for pageNum in [1..totalPages]
				menu.push do (obj={}) =>
					obj.link = urlParse(req.originalUrl).pathname
					obj.link += "?#{config.catalog.elementsPaginationVar}=#{pageNum}" if pageNum > 1
					obj.title = pageNum
					obj.active = if pageNum is page then true else false
					obj
			cb null, menu


module.exports = {CatalogCategoriesMixin}
