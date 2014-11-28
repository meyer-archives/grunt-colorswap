#
# grunt-colorswap
# https://github.com/meyer/grunt-colorswap
#
# Copyright (c) 2014 Mike Meyer
# Licensed under the MIT license.
#
"use strict"

module.exports = (grunt) ->
	demoFileObj = [{
		expand: true
		cwd: "test/fixtures/"
		src: ["*.svg"]
		dest: "test/expected/"
		ext: (ext) ->
			return ext if grunt.task.current.target == "orig"
			"-#{grunt.task.current.target}#{ext}"
	}]

	grunt.initConfig
		colorswap:
			blue:
				files: demoFileObj
				options:
					instructions: "set everything to blue"

			red:
				files: demoFileObj
				options:
					instructions: "colorize #F00"

			similar:
				files: demoFileObj
				options:
					instructions: "set #23D0F1 to #F00 ~20%"

		copy:
			orig:
				files: demoFileObj

		clean:
			expected: ["test/expected/"]

		coffeelint:
			taskAndFilters:
				files: [{
					src: ["tasks/**/*.coffee"]
				}]
			options:
				configFile: "coffeelint.json"

	grunt.loadTasks "tasks"
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-coffeelint"

	grunt.registerTask "default", ["coffeelint", "clean", "copy", "colorswap"]
	grunt.registerTask "test", ["coffeelint"]

	return