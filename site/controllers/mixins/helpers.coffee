path = require 'path'
local = require '../../../utils/localization'

class HelpersMixin
	helpers:
		staticUrl: (relPath) -> path.join '/static/', relPath
		relUrl: (baseUrl, relPath) ->
			return relPath if relPath.charAt(0) isnt '/'
			path.join baseUrl, relPath.slice(1)
	getChargedHelpers: (req) ->
		helpers = {}
		helpers[key] = @helpers[key] for key of @helpers
		helpers.relUrl = do (req) ->
			(relPath) -> helpers.relUrl req.baseUrl, relPath
		helpers

module.exports = {HelpersMixin}
