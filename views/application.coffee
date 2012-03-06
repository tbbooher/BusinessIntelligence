#$ ->
#  alert('foo')

quantize = (d) ->
  "q" + Math.min(8, ~~(data[d.id] * 9 / 12)) + "-9"

data = undefined

path = d3.geo.path()

svg = d3.select("#chart").append("svg")

districts = svg.append("g").attr("id", "districts").attr("class", "Blues")

states = svg.append("g").attr("id", "states")

d3.json "/json/districts.json", (json) ->
  districts.selectAll("path").data(json.features).enter().append("path").attr "d", path

#   districts.selectAll("path").data(json.features).enter().append("path").attr("class", (if data then quantize else null)).attr "d", path
# the d attribute is the path data
# the g attribute is for grouping data

d3.json "/json/us-states.json", (json) ->
  states.selectAll("path").data(json.features).enter().append("path").attr "d", path
  states.selectAll("path").attr("class", "Blues")

# d3.json "/json/unemployment.json", (json) ->
#   data = json
#   districts.selectAll("path").attr "class", quantize
