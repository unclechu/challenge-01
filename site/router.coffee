MainPageHandler = require('./controllers/main-page-handler').MainPageHandler

methods = ['get', 'post']

routes = [
	url: '/'
	handler: MainPageHandler
]

applyRouter = (app, _routes=routes, _methods=methods) ->
	for route in _routes
		handler = new route.handler()
		do (handler) -> for method in _methods
			if method of handler
				do (method) -> app[method] route.url, handler[method]

module.exports = {routes, applyRouter, methods}
