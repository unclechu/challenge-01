mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId


merchantSchema = new Schema
	id:
		ObjectId
		required: true
	name:
		type: String
		required: true

MerchantModel = mongoose.model \
	'MerchantModel', merchantSchema


module.exports = {MerchantModel}
