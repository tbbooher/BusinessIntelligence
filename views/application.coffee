#$ ->
#  alert('foo')

data = undefined
selectedCounty = undefined
district = undefined
highlightColor = d3.rgb(198, 42, 42)
extraTranslateRight = 100

path = d3.geo.path()

svg = d3.select("#chart").append("svg:svg")
map = svg.append("svg:g").attr("class", "map").attr("transform", "translate(" + (extraTranslateRight + 50) + ", 0)")

districts = svg.append("g").attr("id", "districts").attr("class", "Blues")

states = svg.append("g").attr("id", "states")

d3.json "/json/us-states.json", (json) ->
  states.selectAll("path").data(json.features).enter().append("path").attr "d", path
  states.selectAll("path").attr("class", "Blues")

d3.json "/json/short_districts.json", (json) ->
  features = []
  i = 0
  console.log(json);
  districts.selectAll("path").data(json.features).enter().append("path").attr("class", (if json then quantize else null)).attr("d", path).on("mouseover", (d) ->
        d3.select(this).style('fill', highlightColor)
        console.log(d.properties.d_name)
        $('#details').html("district " + d.properties.d_name + " has " + d.properties.auths + " authorizations");

        district = d
        display base for base in JSON.parse(d.properties.bases) when d.properties.base isnt null

  ).on("mouseout", (d) ->
        d3.select(this).style('fill','');
  )

quantize = (d) ->
        "q" + Math.min(8, d.properties.color_index) + "-9"

display = (b) ->
        console.log(b)
        $('#details').append('<p>' + b + '</p>')