path = require 'path'
express = require 'express'

config = require '../utils/config'
router = require './router'

site = express()

site.set 'views', path.join process.cwd(), config.paths.templates
site.set 'view engine', 'jade'

router.applyRouter(site)

module.exports = site
