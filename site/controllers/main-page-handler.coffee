RequestHandler = require('./request-handler').RequestHandler

class MainPageHandler extends RequestHandler
	template: 'catalog-page'
	get: (req, res) =>
		res.render(@template).end()

module.exports = {MainPageHandler}
