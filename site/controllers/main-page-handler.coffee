RequestHandler = require('./request-handler').RequestHandler

class MainPageHandler extends RequestHandler
	get: (req, res) =>
		res.send('^_^').end()

module.exports = {MainPageHandler}
