config = require '../config.json'

env = process.env

config.port = env.PORT if env.PORT?
config.host = env.HOST if env.HOST?

config.paths.static = env.STATIC_PATH if env.STATIC_PATH?
config.paths.templates = env.TEMPLATES_PATH if env.TEMPLATES_PATH?
config.paths.uploaded = env.UPLOADED_PATH if env.UPLOADED_PATH?

config.mongo.port = env.MONGO_PORT if env.MONGO_PORT?
config.mongo.host = env.MONGO_HOST if env.MONGO_HOST?
config.mongo.database = env.MONGO_DATABASE if env.MONGO_DATABASE?

config.lang = env.APP_LANG if env.APP_LANG?

module.exports = config
