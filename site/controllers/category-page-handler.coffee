local = require '../../utils/localization'

{RequestHandler} = require './request-handler'

{CatalogElementModel, CatalogCategoryModel} = require '../models/catalog'
{MerchantModel} = require '../models/merchant'

class CategoryPageHandler extends RequestHandler
	template: 'pages/catalog/category'
	constructor: ->
		super
	requiredData: ['categoriesList', 'elementsList', 'elementsPagination']
	get: (req, res) =>
		@categoryId = req.params[0]
		@getChargedData req, (err, data) =>
			if err
				console.error 'Cannot get charged data:\n', err
				return @serverFail req, res
			CatalogCategoryModel.findOne _id: req.params[0], (err, category) =>
				if err
					console.error "Cannot find category by id '#{req.params[0]}':\n", err
					res.status(404).end '404 Not Found'
					return
				data.pageTitle = category.name
				res.render @template, data

module.exports = {CategoryPageHandler}
