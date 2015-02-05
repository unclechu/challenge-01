{MainPageHandler} = require './controllers/main-page-handler'
{SearchPageHandler} = require './controllers/search-page-handler'

methods = ['get', 'post']

routes = [
	url: '/'
	handler: MainPageHandler
,
	url: '/search/'
	handler: SearchPageHandler
]

applyRouter = (app, _routes=routes, _methods=methods) ->
	for route in _routes
		handler = new route.handler()
		for method in _methods
			if method of handler
				app[method] route.url, handler[method]

module.exports = {routes, applyRouter, methods}
