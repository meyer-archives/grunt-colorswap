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
		dest: "tmp/"
		ext: (ext) ->
			unless grunt.task.current.target == "orig"
				return "-#{grunt.task.current.target}#{ext}"
			ext
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


		copy:
			orig:
				files: demoFileObj

		clean:
			tmp: ["tmp/"]

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
	grunt.registerTask "test", ["coffeelint", ]

	return