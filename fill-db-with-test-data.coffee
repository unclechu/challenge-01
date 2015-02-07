#!./coffee

mongoose = require 'mongoose'

require './utils/mongoose'
{CatalogElementModel, CatalogCategoryModel} = require './site/models/catalog'
{MerchantModel} = require './site/models/merchant'

ObjectId = mongoose.Schema.ObjectId

catalogCategories = [
	name: 'foo'
,
	name: 'bar'
,
	name: 'another category'
]

catalogItems = [
	name: 'item foo'
	image: 'testpic1.png'
	price: 100.02
,
	name: 'item bar'
	image: 'testpic2.png'
	price: 200.03
,
	name: 'item 1'
	image: 'testpic1.png'
	price: 300.04
,
	name: 'item 2'
	image: 'testpic1.png'
	price: 100.05
,
	name: 'item 3'
	image: 'testpic2.png'
	price: 200.06
,
	name: 'item 4'
	image: 'testpic3.png'
	price: 300.07
,
	name: 'item 5'
	image: 'testpic1.png'
	price: 100.08
,
	name: 'item 6'
	image: 'testpic2.png'
	price: 200.0
,
	name: 'item 7'
	image: 'testpic3.png'
	price: 300.0
,
	name: 'item 8'
	image: 'testpic1.png'
	price: 100.0
,
	name: 'item 9'
	image: 'testpic2.png'
	price: 200.0
,
	name: 'item 10'
	image: 'testpic3.png'
	price: 300.0
,
	name: 'item 11'
	image: 'testpic1.png'
	price: 100.0
,
	name: 'item 12'
	image: 'testpic2.png'
	price: 200.0
,
	name: 'item 13'
	image: 'testpic3.png'
	price: 300.0
,
	name: 'item 14'
	image: 'testpic1.png'
	price: 100.0
,
	name: 'item 15'
	image: 'testpic2.png'
	price: 200.0
,
	name: 'item 16'
	image: 'testpic3.png'
	price: 300.0
,
	name: 'item 17'
	image: 'testpic1.png'
	price: 100.0
,
	name: 'item 18'
	image: 'testpic2.png'
	price: 200.0
,
	name: 'item 19'
	image: 'testpic3.png'
	price: 300.0
,
	name: 'item 20'
	image: 'testpic1.png'
	price: 100.0
,
	name: 'item 21'
	image: 'testpic2.png'
	price: 200.0
]

merchants = [
	name: 'John'
,
	name: 'Sam'
,
	name: 'Dexter'
]

catalogCategoriesCounter = 0
catalogItemsCounter = 0
merchantsCounter = 0

itemsFill = ->
	addItem = (categories, i, item) ->
		modelItem = new CatalogElementModel()
		for key of item
			modelItem[key] = item[key]
		modelItem.categories = categories
		if i < 5
			merchantName = 'John'
		else if i < 10
			merchantName = 'Sam'
		else
			merchantName = 'Dexter'
		MerchantModel.findOne name: merchantName, (err, elem) ->
			if err
				console.error(
					"Cannot find merchant by name '#{merchantName}':\n"
					err
				)
			modelItem.merchant = elem._id
			modelItem.save (err) ->
				if err
					console.error(
						"Cannot create catalog item by name #{item.name}"
						err
					)
				catalogItemsCounter++
				completeTrigger()
	for item, i in catalogItems
		do (categories=[], i, item) ->
			if i < 5
				CatalogCaterogyModel.findOne name: 'foo', (err, elem) ->
					if err
						console.error "Cannot find category by name 'foo':\n", err
					categories.push elem._id
					addItem categories, i, item
			else if i < 10
				CatalogCaterogyModel.findOne name: 'bar', (err, elem) ->
					if err
						console.error "Cannot find category by name 'bar':\n", err
					categories.push elem._id
					addItem categories, i, item
			else
				cb2 = (err, elem) ->
					if err
						console.error(
							"Cannot find category by name 'another category':\n"
							err
						)
					categories.push elem._id
					addItem categories, i, item
				CatalogCaterogyModel.findOne name: 'bar', (err, elem) ->
					if err
						console.error "Cannot find category by name 'bar':\n", err
					categories.push elem._id
					CatalogCaterogyModel.findOne name: 'another category', cb2

isCatalogCategoriesFilled = no
isCatalogItemsFilled = no
isMerchantsFilled = no

completeTrigger = ->
	return unless catalogCategoriesCounter is catalogCategories.length
	unless isCatalogCategoriesFilled
		console.log 'Catalog categories is filled'
		isCatalogCategoriesFilled = yes
	return unless merchantsCounter is merchants.length
	unless isMerchantsFilled
		console.log 'Merchants is filled'
		isMerchantsFilled = yes
	itemsFill?()
	itemsFill = null
	return unless catalogItemsCounter is catalogItems.length
	unless isCatalogItemsFilled
		console.log 'Catalog items is filled'
		isCatalogItemsFilled = yes

	console.log 'Completed!'
	mongoose.disconnect()

for item in catalogCategories
	modelItem = new CatalogCaterogyModel()
	modelItem.name = item.name
	modelItem.save (err) ->
		console.error 'Cannot create catalog category:\n', err if err
		catalogCategoriesCounter++
		completeTrigger()

for item in merchants
	modelItem = new MerchantModel()
	modelItem.name = item.name
	modelItem.save (err) ->
		console.error 'Cannot create merchant:\n', err if err
		merchantsCounter++
		completeTrigger()
