"use strict"

Chromath = require "chromath"
grunt = require "grunt"

formula = undefined

module.exports.processInstructions = (instructions) ->
	unless matches = instructions.match(/^\S+(?: using (\S+))?$/)
		throw "Invalid instructions! Expected format `desaturate (optional formula: xarg or sun)`"

	try
		formula = matches[2]
		# grunt.log.ok "newColor: #{newColor.toHexString()}"
	catch e
		throw "#{matches[1]} is not a valid color"

	true

module.exports.processColor = (color) ->
	newColor = new Chromath.desaturate(color, formula)
	grunt.verbose.write " --desaturate--> #{newColor.toString()}"
	newColor