#!/usr/bin/env ruby

# TODO: Make this thing command-line configurable

require "erb"
require "color"

# thx https://github.com/wojtha/redmine_alerts/blob/master/lib/color.rb
def hsl2rgb(h, s, l)
  # Convert to decimals
  h /= 360.0
  s /= 100.0
  l /= 100.0

  m2 = (l <= 0.5) ? l * (s + 1) : l + s - l * s
  m1 = l * 2.0 - m2;

  hue2rgb = lambda do |m1x, m2x, hx|
    hx = (hx < 0) ? hx + 1 : ((hx > 1) ? hx - 1 : hx)
    if (hx * 6.0 < 1) then m1x + (m2x - m1x) * hx * 6.0
    elsif (hx * 2.0 < 1) then m2x
    elsif (hx * 3.0 < 2) then m1x + (m2x - m1x) * (2/3.0 - hx) * 6.0
    else m1x end
  end

  # Convert to 0-255
  [
    hue2rgb.call(m1, m2, h + 1/3.0),
    hue2rgb.call(m1, m2, h),
    hue2rgb.call(m1, m2, h - 1/3.0)
  ].map do |n|
    (n * 255.0).round
  end
end

Padding = 2
Border = 20
BlockSize = 10

ValueRanges = {
  "h" => [0, 360],
  "s" => [0, 100],
  "l" => [0, 100]
}

color = {
  "h" => 180,
  "s" => 100,
  "l" => 50
}

ColorGridYMax = 30
ColorGridXMax = 30

ColorGridDocHeight =  Border * 2 + ColorGridYMax * (BlockSize + Padding) + BlockSize
ColorGridDocWidth = Border * 2 + ColorGridXMax * (BlockSize + Padding) + BlockSize

# h, s, or l
ColorGridX = "l" # v
ColorGridY = "h" # >

colors = []

BorderMinL = 90

[*0..ColorGridYMax].each do |y|
  color[ColorGridY] = ValueRanges[ColorGridY][0] + y.to_f / ColorGridYMax * ValueRanges[ColorGridY][1]

  [*0..ColorGridXMax].each do |x|
    color[ColorGridX] = ValueRanges[ColorGridX][0] + x.to_f / ColorGridXMax * ValueRanges[ColorGridX][1]

    colors << [
      # x
      Border + x * (Padding + BlockSize),
      # y
      Border + y * (Padding + BlockSize),
      # color
      "rgb(%s, %s, %s)" % hsl2rgb(color["h"], color["s"], color["l"]),
      "rgb(%s, %s, %s)" % hsl2rgb(color["h"], color["s"], BorderMinL),
      color["l"] > BorderMinL
    ]
  end
end

puts ERB.new(DATA.read).result(binding).strip

__END__

<?xml version="1.0" encoding="utf-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="<%= ColorGridDocWidth %>px" height="<%= ColorGridDocHeight %>px">
<% colors.each do |x, y, fill, stroke, too_light| %>
  <rect
    x="<%= x + (too_light ? 0.5 : 0) %>"
    y="<%= y + (too_light ? 0.5 : 0) %>"
    style="fill: <%= fill %>;"
<% if too_light %>
    stroke="<%= stroke %>"
    stroke-width="1"
<% end %>
    width="<%= BlockSize - (too_light ? 1 : 0) %>"
    height="<%= BlockSize - (too_light ? 1 : 0) %>"
  />
<% end %>
</svg>