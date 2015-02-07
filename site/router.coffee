{MainPageHandler} = require './controllers/main-page-handler'
{CategoryPageHandler} = require './controllers/category-page-handler'
{SearchPageHandler} = require './controllers/search-page-handler'
{Error404PageHandler} = require './controllers/error-404-page-handler'

methods = ['get', 'post']

routes = [
	url: '/'
	handler: MainPageHandler
,
	url: '/search/'
	handler: SearchPageHandler
,
	url: /^\/section_([0-9a-z]+)\.html$/
	handler: CategoryPageHandler
,
	url: '*'
	handler: Error404PageHandler
]

applyRouter = (app, _routes=routes, _methods=methods) ->
	for route in _routes
		handler = new route.handler()
		for method in _methods
			if method of handler
				app[method] route.url, handler[method]

module.exports = {routes, applyRouter, methods}
