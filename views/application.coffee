#$ ->
#  alert('foo')

data = undefined
selectedDistrict = undefined
saipehighlights = undefined
states = undefined
currentDistrict = undefined
members = undefined

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
districtName = svg.append("svg:text").attr("class", "year").attr("transform", "translate(15, 50)").text('');
districtPic = svg.append("svg:image").attr("class", "pic").attr("transform", "translate(15, 150)").attr("width",100).attr("height",100)

# let us build a legend
legend = svg.append("svg:g").attr("transform", "translate(" + (904 + extraTranslateRight) + ", 240)")
legendGradient = legend.append("svg:g")
legendTicks = legend.append("svg:g")

# let us store some states -- should we use these?
d3.json "/json/us-states.json", (json) ->
  states = json

d3.json "/json/district_to_member.json", (json) ->
  members = json

# let us load saipe data
#d3.json "../static/data/saipehighlights.json", (json) ->
#  saipehighlights = json

# get district name
getDistrictName = (d) ->
  d.properties.d_name

# draw the spark in the upper right
drawSpark = ->
  if selectedDistrict or currentDistrict
    spark.style "visibility", "visible"
    districtName.style "visibility", "visible"
    districtPic.style "visibility", "visible"
    name = undefined
    if selectedDistrict
      name = getDistrictName(selectedDistrict.__data__)
    else
      name = getDistrictName(currentDistrict)
    districtName.text(name)
    districtPic.attr("xlink:href","/images/" + members[name] + "-100px.jpeg")
  else
    spark.style "visibility", "hidden"
    districtName.style "visibility", "hidden"
    districtPic.style "visibility", "hidden"

drawMap = ->
  # we fill in all the path elements (pretty confusing)
  map.selectAll("path").attr("class", quantize)

#########################################################################
#                         Here it the big deal
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
    drawSpark()
  )

  drawTitleAndMisc()
  drawMap()

standard_color = (d) ->
  'pink'

quantize = (d) ->
  "q" + Math.min(8, d.properties.color_index) + "-9"

display = (b) ->
  $('#details').append('<p>' + b + '</p>')

# do we want notes?
drawTitleAndMisc = ->
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 715)").attr("text-anchor", "end").text "By: TIM BOOHER AND JOHN SWISHER | March 2012"
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 730)").attr("text-anchor", "end").text "Data: MPES Database, Small Area Income & Poverty Estimates, U.S. Census Bureau"
