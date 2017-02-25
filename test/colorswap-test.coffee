task = require "../tasks/colorswap.coffee"

exports.ColorSwapTest =
	
	setup: (callback) ->
		return

	testColorize: () ->
		"colorize #00F"
		return

	testColorizeAlias: () ->
		"colorise #00F"
		return

	testDesaturateXARG: () ->
		"desaturate xarg"
		return
	
	testDesaturateSUN: () ->
		"desaturate sun"
		return
	
	testSet: () ->
		"set everything to #00F"
		return
	
	testSetApproximate: () ->
		"set #F00 to #00F ~10%"
		return
	
	testSetAlias: () ->
		"replace everything with #00F"
		return