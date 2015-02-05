mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId


catalogElementSchema = new Schema
	id:
		ObjectId
		required: true
	name:
		type: String
		required: true
	image:
		type: String
	price:
		type: Float
		required: true
	merchant:
		type: ObjectId
		required: true
	category:
		type: [ObjectId]

CatalogElementModel = mongoose.model \
	'CatalogElementModel', catalogElementSchema


catalogCaterogySchema = new Schema
	id:
		ObjectId
		required: true
	name:
		type: String
		required: true

CatalogCaterogyModel = mongoose.model \
	'CatalogCaterogyModel', catalogCaterogySchema


module.exports = {CatalogElementModel, CatalogCaterogyModel}
