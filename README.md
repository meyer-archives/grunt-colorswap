# grunt-colorswap

**grunt-colorswap** does one thing: it looks in the files you specify for strings that look like colors, runs the set of instructions you provide on each of these strings, then replaces those original strings with the updated color string.

Right now, **grunt-colorswap** works on hex and RGB color strings. If you read regex, the [color-matching regexes][omgregex] might be of interest to you.

## Using grunt-colorswap

I’d recommend checking out this project’s [Gruntfile][]. Sample Gruntfile (in CoffeeScript, fight me):

	module.exports = (grunt) ->

		grunt.initConfig

			colorswap:
				blue:
					files: ["tobias.svg"]
					options:
						instructions: "colorize #00F"

		grunt.loadNpmTasks "grunt-colorswap"

Running `grunt colorswap` will colorize the specified SVG file with the color blue using the **colorize** filter.

Available filters can be found in [/tasks/filters][filters].

## Filters: the nitty gritty

Filters have two required methods, `init` and `processColor`.

The first method, `init`, validates instruction strings, and has only one parameter: the instruction string. An error should be thrown if the filter is called (`set …`), but the instruction string is something the filter doesn’t understand (`set hungry to true`). This method is expected to return `true` if everything went alright.

The second and last method, `processColor`, is what does the per-color manipulation. `processColor` receives one argument: a Chromath object representing the color to be modified. `processColor` is expected to return a Chromath object as well.

`chromath` and `color-difference` are available to filters.

[omgregex]: https://github.com/meyer/grunt-colorswap/blob/master/tasks/colorswap.coffee#L20-L23
[gruntfile]: https://github.com/meyer/grunt-colorswap/blob/master/Gruntfile.coffee
[filters]: https://github.com/meyer/grunt-colorswap/tree/master/tasks/filters
[shapes-red]: https://github.com/meyer/grunt-colorswap/blob/master/test/expected/shapes-crazy-red.svg
[colorize-lines]: https://github.com/meyer/grunt-colorswap/blob/master/tasks/filters/colorize.coffee#L20-L23

## TODOs

- [ ] Friendlier instructions
- [ ] …with pictures
- [ ] Tests
- [ ] Convert RGB to RGB and hex to hex instead of everything to hex

## Shelved Ideas
- **instructions.yaml/txt**: tasks can be dumped into a text file. Key-value kind of deal. Didn’t end up being important. Also, hex colors are read as comments in YAML.
