#
# grunt-colorswap
# https://github.com/meyer/grunt-colorswap
#
# Copyright (c) 2014 Mike Meyer
# Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->
	grunt.initConfig
		colorswap:
			justBlueMyself:
				options:
					instructions: "set everything to blue"

				files: [{
					expand: true
					cwd: "test/fixtures/"
					src: ["*.svg"]
					dest: "tmp/everything-blue"
				}]

			colorizeToRed:
				options:
					instructions: "colorize #F00"

				files: [{
					expand: true
					cwd: "test/fixtures/"
					src: ["*.svg"]
					dest: "tmp/colorize-red"
				}]

	grunt.loadTasks "tasks"
	grunt.registerTask "default", ["colorswap"]

	return