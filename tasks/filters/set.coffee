"use strict"

grunt = require "grunt"
Chromath = require "Chromath"

targetColor = ""
replacementColor = ""

module.exports.processInstructions = (instructions) ->
	unless matches = instructions.match(/^\S+ (\S+) (?:with|to) (\S+)$/)
		throw "Invalid instructions! Expected format: `replace/set COLOR with/to NEWCOLOR`"

	unless replacementColor = new Chromath(matches[2])
		grunt.log.warn "`#{matches[2]}` is not a valid colour"

	if ~["*","all","everything"].indexOf matches[1]
		targetColor = "everything"
	else
		unless targetColor = new Chromath(matches[1])
			grunt.log.warn "`#{matches[1]}` is not a valid colour"

	true

# processColor recieves a Chromath object and an instruction string
module.exports.processColor = (color) ->
	if targetColor == "everything" || color.toHexString() == targetColor.toHexString()
		grunt.verbose.ok " - Replacing #{color.toString()} --> #{replacementColor.toString()}"
		replacementColor
	else
		grunt.verbose.ok " - Ignoring #{color.toString()}"
		color