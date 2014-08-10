#
# grunt-colorswap
# https://github.com/meyer/grunt-colorswap
#
# Copyright (c) 2014 Mike Meyer
# Licensed under the MIT license.
#

"use strict"

module.exports = (grunt) ->
	Chromath = require "chromath"

	multiTask = ->
		options = @options(
			# TODO: Probably need to be a bit better about matching weird spaces
			regexes: [
				/(rgb\((?:(?:[01]?\d?\d|2[0-4]\d|25[0-5])\,\s*?){2}(?:[01]?\d?\d|2[0-4]\d|25[0-5])\))/gi
				/(#(?:[\dA-F]{3}){1,2})/gi
			]
		)

		@requiresConfig "#{@name}.#{@target}.options.instructions"

		# Allow for multiple instructions
		instructionArray = [].concat options.instructions

		# List of filters to run
		todoList = []

		instructionArray.forEach (instructions) ->
			# First word == filter name
			filterName = instructions.toLowerCase().split(" ")[0]

			try
				filter = require "./filters/#{filterName}"
				filter.processInstructions instructions

				grunt.log.ok "Loaded filter `#{filterName}`"
			catch e
				grunt.log.warn "Can’t load filter `#{filterName}`: #{e}"
				return

			todoList.push [filterName, filter]


		@files.forEach (f) ->
			grunt.log.ok "Processing `#{f.src}`"

			# Get the text contents of the file
			fileSource = grunt.file.read f.src

			originalColors = []
			colorObjects = []

			# Loop through each regex, see if it matches a valid colour
			options.regexes.forEach (rgx) ->

				# Loop through regex matches
				while match = rgx.exec(fileSource)
					try
						# Validate the regex match
						color = new Chromath(match[1])
						originalColors.push match[1]
						colorObjects.push color
					catch e
						grunt.log.warn "Regex matched an invalid color string (#{colorString})"

				return

			if originalColors.length == 0
				grunt.log.warn "No valid colors were found :C"
				return

			# Valid original colors
			originalColors.forEach (targetString, idx) ->

				# Run each filter
				todoList.forEach (m) ->
					[filterName, filter] = m

					try
						replacement = filter.processColor(colorObjects[idx])
						newTargetString = replacement.toHexString()
						fileSource = fileSource.replace(targetString, newTargetString)

						# 2CHAINZ
						colorObjects[idx] = replacement
						targetString = newTargetString

					catch e
						grunt.log.warn "Filter `#{options.instructions}` did not run:\n - #{e}"

			grunt.file.write f.dest, fileSource
			grunt.log.ok "File `#{f.dest}` created."
			grunt.log.writeln()
			return

		return

	grunt.registerMultiTask "colorswap",  "Manipulate colors in any given file.",  multiTask
	grunt.registerMultiTask "colourswap", "Manipulate colours in any given file.", multiTask

	return