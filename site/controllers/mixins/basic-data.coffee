class BasicDataMixin
	getChargedData: (req) ->
		data = {}
		data[key] = @data[key] for key of @data
		helpers = @getChargedHelpers req
		data[key] = helpers[key] for key of helpers
		data.menu = @getChargedMenu req
		data

module.exports = {BasicDataMixin}
