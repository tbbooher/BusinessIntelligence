#$ ->
#  alert('foo')

data = undefined
selectedDistrict = undefined
saipehighlights = undefined
states = undefined
currentDistrict = undefined
#spark = undefined
#map = undefined
extraTranslateRight = 100

# nodata
highlightColor = d3.rgb(198, 42, 42)
noData = "rgb(255,255,255)"

path = d3.geo.path()

# build our map
svg = d3.select("#chart").append("svg:svg")
map = svg.append("svg:g").attr("class", "map Blues").attr("transform", "translate(" + (extraTranslateRight + 50) + ", 0)")
spark = svg.append("svg:g").attr("class", "spark").attr("transform", "translate(55, 230)").style("visibility", "hidden")

# need to change this to district name
districtName = svg.append("svg:g").attr("class", "districtName").attr("transform", "translate(15, 260)").style("visibility", "hidden").insert("svg:text").attr("class","district").text("district placeholder")

# let us build a legend
legend = svg.append("svg:g").attr("transform", "translate(" + (904 + extraTranslateRight) + ", 240)")
legendGradient = legend.append("svg:g")
legendTicks = legend.append("svg:g")

# let us store some states -- should we use these?
d3.json "/json/us-states.json", (json) ->
  states = json

# let us load saipe data
#d3.json "../static/data/saipehighlights.json", (json) ->
#  saipehighlights = json

# draw the spark in the upper right
drawSpark = ->
  console.log('drawing spark')
  if selectedDistrict or currentDistrict
    console.log('visible')
    spark.style "visibility", "visible"
    districtName.style "visibility", "visible"
    name = undefined
    if selectedDistrict  # only possible with click events
      console.log('selected district')
      name = getDistrictName(selectedDistrict.__data__)
    else
      console.log('not selected district')
      name = getDistrictName(currentDistrict)
      console.log(name)
    districtName.selectAll("text").data(name).text (d,i) ->
      console.log('setting district name')
      console.log(d.properties.d_name)
      d.properties.d_name
  else
    console.log('hiding spark')
    spark.style "visibility", "hidden"
    districtName.style "visibility", "hidden"

drawMap = ->
  # we fill in all the path elements (pretty confusing)
  map.selectAll("path").attr("class", quantize)

#########################################################################
#                         Here is the big deal
#########################################################################
d3.json "/json/short_districts.json", (json) ->
  features = []
  i = 0
  while i < json.features.length
    feature = json.features[i]
    features.push feature if feature.properties
    i++
  # ensure a click resets things
  svg.on "click", (d,i) ->
    if selectedDistrict
      d3.select(selectedDistrict).style("fill",'').attr "class", quantize # need to look up districtColor
      selectedDistrict = null

  map.selectAll("path").data(features).enter().append("svg:path").attr("d", path).on("mouseover", (d) ->
    unless selectedDistrict
      d3.select(this).style "fill", highlightColor
      currentDistrict = d
      drawSpark()
  ).on("mouseout", (d) ->
    d3.select(this).style("fill",'').attr "class", quantize unless selectedDistrict
    currentDistrict = null
    #drawSpark()
  )

  drawTitleAndMisc()
  drawMap()

quantize = (d) ->
  "q" + Math.min(8, d.properties.color_index) + "-9"

display = (b) ->
  console.log('display called')
  $('#details').append('<p>' + b + '</p>')

# do we want notes?
drawTitleAndMisc = ->
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 715)").attr("text-anchor", "end").text "By: TIM BOOHER AND JOHN SWISHER | March 2012"
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 730)").attr("text-anchor", "end").text "Data: MPES Database, Small Area Income & Poverty Estimates, U.S. Census Bureau"

# get district name
getDistrictName = (d) ->
  "District: " + d.properties.d_name