$ ->
  alert('foo')

quantize = (d) ->
  "q" + Math.min(8, ~~(data[d.id] * 9 / 12)) + "-9"
data = undefined
path = d3.geo.path()

svg = d3.select("#chart").append("svg")

counties = svg.append("g").attr("id", "counties").attr("class", "Blues")

states = svg.append("g").attr("id", "states")

d3.json "/json/us-counties.json", (json) ->
  counties.selectAll("path").data(json.features).enter().append("path").attr("class", (if data then quantize else null)).attr "d", path

d3.json "/json/us-states.json", (json) ->
  states.selectAll("path").data(json.features).enter().append("path").attr "d", path

d3.json "/json/unemployment.json", (json) ->
  data = json
  counties.selectAll("path").attr "class", quantize