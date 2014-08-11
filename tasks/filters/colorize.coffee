"use strict"

Chromath = require "chromath"
grunt = require "grunt"

newHSL = []

module.exports.processInstructions = (instructions) ->
	unless matches = instructions.match(/^\S+ (?:(?:to|with) )?(\S+)$/)
		throw "Invalid instructions! Expected format `colorize COLOR`"

	try
		newHSL = new Chromath(matches[1]).toHSLArray()
	catch e
		throw "#{matches[1]} is not a valid color"

	true

# processColor recieves a Chromath object
module.exports.processColor = (color) ->
	newColor = new Chromath.hsl(newHSL[0], newHSL[1], color.l)
	grunt.verbose.ok " - Colorizing #{color.toString()} --> #{newColor.toString()}"
	newColor