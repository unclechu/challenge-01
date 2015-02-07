{RequestHandler} = require './request-handler'

class Error404PageHandler extends RequestHandler
	constructor: -> super
	get: (req, res) => res.status(404).end '404 Not Found'

module.exports = {Error404PageHandler}
