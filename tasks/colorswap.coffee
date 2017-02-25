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

	pad = (str, places, padWith=" ") ->
		(new Array(places+1).join(padWith) + str).slice(-places)

	multiTask = ->
		options = @options(
			# TODO: Probably need to be a bit better about matching weird spaces
			# TODO: Use block regex format to make this more readable
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
				unless typeof filter.init == "function"
					throw new Error "missing required method init"

				if typeof filter.processColour == "function"
					filter.processColor = filter.processColour

				unless typeof filter.processColor == "function"
					throw new Error "missing required method processColor"

				filter.init instructions

				grunt.verbose.ok "Loaded filter `#{filterName}` for `#{instructions}`"
			catch e
				grunt.log.warn "Can’t load filter `#{filterName}`: #{e}"
				return

			todoList.push [filterName, filter]


		@files.forEach (f, idx) =>
			grunt.verbose.ok "Processing `#{f.src}` (#{idx+1}/#{@files.length})"

			# Get the text contents of the file
			fileSource = grunt.file.read f.src

			grunt.verbose.writeln()

			originalColors = []
			colorObjects = []

			# Loop through each regex, see if it matches a valid color
			options.regexes.forEach (rgx) ->

				# Loop through regex matches
				while match = rgx.exec(fileSource)
					try
						# Validate the regex match
						color = new Chromath(match[1])
						originalColors.push match[1]
						colorObjects.push color
					catch e
						grunt.log.warn "Regex matched an invalid color string (#{match[1]})"

				return

			if originalColors.length == 0
				grunt.log.warn "No valid colors were found :C"
				return

			# Valid original colors
			originalColors.forEach (targetString, idx) ->

				originalColor = colorObjects[idx].toString()
				grunt.verbose.ok "#{idx+1}/#{originalColors.length} -- #{originalColors[idx]}"

				# Run each filter
				todoList.forEach ([filterName, filter]) ->

					try
						replacement = filter.processColor(colorObjects[idx])
						newTargetString = replacement.toHexString()

						if originalColor != newTargetString
							fileSource = fileSource.replace(targetString, newTargetString)
							grunt.verbose.writeln "#{filterName}: #{originalColor} ---> #{newTargetString}"
						else
							grunt.verbose.writeln "#{filterName}: Color unchanged."

						colorObjects[idx] = replacement
						targetString = newTargetString
					catch e
						grunt.log.warn "Filter `#{options.instructions}` did not run:\n - #{e}"

					return

				grunt.verbose.writeln ""

			grunt.file.write f.dest, fileSource
			grunt.verbose.ok "File `#{f.dest}` created."
			grunt.verbose.writeln()
			return

		grunt.log.ok "Ran `#{instructionArray.join "`, `"}` on #{@files.length} file#{"s" unless @files.length == 1}"

		return

	grunt.registerMultiTask "colorswap",  "Manipulate colors in any given file.",  multiTask
	grunt.registerMultiTask "colourswap", "Manipulate colours in any given file.", multiTask

	return