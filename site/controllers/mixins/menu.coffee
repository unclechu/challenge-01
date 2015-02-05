local = require '../../../utils/localization'

class MenuDataMixin
	data: {}
	constructor: ->
		@data.menu = [
			href: '/'
			title: local.sections.catalogCategories
		,
			href: '/search'
			title: local.sections.search
		]
		super
	getChargedMenu: (req) ->
		menu = (item for item in @data.menu)
		newMenu = []
		for item in menu
			newItem = {}
			for key of item
				if key is 'href'
					newItem.href = @helpers.relUrl req.baseUrl, item.href
					if item.href.indexOf(req.url) is 0
						if item.href is req.url
							newItem.current = true
							newItem.active = true
						else if item.href is '/'
							newItem.active = true
				else
					newItem[key] = item[key]
			newMenu.push newItem
		newMenu

module.exports = {MenuDataMixin}
