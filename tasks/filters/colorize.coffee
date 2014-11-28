"use strict"

Chromath = require "chromath"
grunt = require "grunt"

newHSL = []

module.exports.init = (instructions) ->
	unless matches = instructions.match(/^\S+ (\S+)$/)
		throw new Error "Invalid instructions! Expected format `colorize COLOR`"

	try
		newHSL = new Chromath(matches[1]).toHSLArray()
	catch e
		throw new Error "#{matches[1]} is not a valid color"

	true

module.exports.processColor = (color) ->
	new Chromath.hsl(newHSL[0], newHSL[1], color.l)