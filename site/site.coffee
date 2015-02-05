express = require 'express'
jade = require 'jade'

config = require '../config.json'
router = require './router'

site = express()
site.engine 'jade', jade.__express

methods = ['get', 'post']

applyRouter = (app, router) ->
	for route in router
		handler = new route.handler()
		do (handler) ->
			for method in methods
				if method of handler
					do (method) ->
						app[method] route.url, ->
							handler[method].apply null, arguments

applyRouter(site, router)

module.exports = site
