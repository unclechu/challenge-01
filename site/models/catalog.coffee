mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId


catalogElementSchema = new Schema
	name:
		type: String
		required: true
	image:
		type: String
	price:
		type: Number
		required: true
	merchant:
		type: ObjectId
		required: true
	categories:
		type: [ObjectId]

CatalogElementModel = mongoose.model \
	'catalog_elements', catalogElementSchema


catalogCaterogySchema = new Schema
	name:
		type: String
		required: true

CatalogCaterogyModel = mongoose.model \
	'catalog_categories', catalogCaterogySchema


module.exports = {
	catalogElementSchema
	CatalogElementModel
	catalogCaterogySchema
	CatalogCaterogyModel
}
