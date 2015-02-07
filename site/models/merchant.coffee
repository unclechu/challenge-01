mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId


merchantSchema = new Schema
	name:
		type: String
		required: true

MerchantModel = mongoose.model \
	'merchants', merchantSchema


module.exports = {
	merchantSchema
	MerchantModel
}
