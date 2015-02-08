lunr = require 'lunr'
{parse: urlParse} = require 'url'
qs = require 'querystring'

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

	descSearchSortByScore = (a, b) ->
		if a.score < b.score
			1
		else if a.score > b.score
			-1
		else
			0

	searchFilter = (searchText, menu) ->
		newMenu = []
		idx = lunr ->
			@ref '_id'
			@field 'name'
			@field 'price'
			@field 'categories'
			@field 'merchant'
		for item in menu
			idx.add
				_id: item._id
				name: item.name
				price: item.price.toString()
				categories: (x.name for x in item.categories).join ' '
				merchant: item.merchant.name
		res = idx.search searchText
		newMenu = []
		for menuItem in menu
			for searchItem in res
				if searchItem.ref.toString() is menuItem._id.toString()
					menuItem.score = searchItem.score
					newMenu.push menuItem
		newMenu.sort descSearchSortByScore
		newMenu

	getElements = ({req, cb, page, skip, limit, ids}) ->
		menu = []

		getListCb = (err, list) =>
			return cb err if err

			start = ->
				getElementsLoop()
			complete = ->
				completeCb null, menu

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

		if req.catalogElementsBySearch?
			query = {}
			fields = null
			options = {skip, limit}
			options = null unless page?
			completeCb = (err, menu) =>
				return cb err if err
				menu = searchFilter req.query.q, menu unless ids?
				cb null, menu
			if ids
				CatalogElementModel.find query, fields, options
					.where('_id').in ids
					.exec getListCb
			else
				CatalogElementModel.find query, fields, options, getListCb
		else
			query = categories: @categoryId
			fields = null
			options = {skip, limit}
			completeCb = (err, menu) =>
				return cb err if err
				cb null, menu
			CatalogElementModel.find query, fields, options, getListCb

	getPageInfo = (req, cb) ->
		getElementsCb = (err, menu) ->
			return cb err if err
			count = menu.length

			ids = (x._id.toString() for x in menu)

			page = parseInt req.query[config.catalog.elementsPaginationVar], 10
			page = 1 if isNaN page
			skip = config.catalog.elementsOnPage * (page - 1)
			limit = config.catalog.elementsOnPage
			totalPages = Math.ceil count / limit
			if page < 1 or page > totalPages
				skip = 0
				limit = 0

			cb null, {page, skip, limit, totalPages, ids}

		getElements.call @, {req, cb:getElementsCb, page:null, skip:null, limit:null, ids:null}

	getChargedCatalogElements: (req, cb) ->
		return cb new Error 'No helpers for getChargedCatalogCategories()' unless @helpers?
		getPageInfo.call @, req, (err, {page, skip, limit, totalPages, ids}) =>
			return cb err if err
			getElements.call @, {req, cb, page, skip, limit, ids}

	getCatalogElementsPagination: (req, cb) ->
		getPageInfo.call @, req, (err, {page, skip, limit, totalPages}) =>
			return cb err if err
			menu = []
			pagiVar = config.catalog.elementsPaginationVar
			return cb null, menu if totalPages <= 0
			for pageNum in [1..totalPages]
				menu.push do (obj={}) =>
					url = urlParse req.originalUrl
					query = qs.parse url.query
					query[pagiVar] = pageNum
					delete query[pagiVar] if pageNum is 1
					query = qs.stringify query
					obj.link = url.pathname
					obj.link += "?#{query}" if query isnt ''
					obj.title = pageNum
					obj.active = if pageNum is page then true else false
					obj
			cb null, menu


module.exports = {CatalogCategoriesMixin}
