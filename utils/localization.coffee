local = require '../localization.json'
config = require './config'

module.exports = local[config.lang]
