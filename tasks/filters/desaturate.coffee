"use strict"

Chromath = require "chromath"
grunt = require "grunt"

formula = undefined

module.exports.init = (instructions) ->
	unless matches = instructions.match(/^\S+(?: using (\S+))?$/)
		throw new Error "Invalid instructions! Expected format `desaturate (optional formula: xarg or sun)`"

	try
		formula = matches[2]
		# grunt.log.ok "newColor: #{newColor.toHexString()}"
	catch e
		throw new Error "#{matches[1]} is not a valid color"

	true

module.exports.processColor = (color) ->
	new Chromath.desaturate(color, formula)