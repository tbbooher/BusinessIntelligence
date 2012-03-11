#$ ->
#  alert('foo')

data = undefined
selectedDistrict = undefined
saipehighlights = undefined
states = undefined
currentDistrict = undefined
members = undefined
demographics = undefined
i = 0

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
districtPic = svg.append("svg:image").attr("class", "pic").attr("transform", "translate(15, 90)").attr("width",100).attr("height",100)
geographyPic = svg.append("svg:image").attr("class", "pic").attr("transform", "translate(700, 475)").attr("width",200).attr("height",150)
districtBases = svg.append("svg:g").attr("class", "bases").attr("transform", "translate(15, 200)");
unemployment = svg.append("svg:text").attr("class", "a_base").attr("transform", "translate(15, 210)").text('');
percent_military = svg.append("svg:text").attr("class", "a_base").attr("transform", "translate(15, 230)").text('');

# let us build a legend
legend         = svg.append("svg:g").attr("transform", "translate(" + (904 + extraTranslateRight) + ", 240)")
legendGradient = legend.append("svg:g")
legendTicks    = legend.append("svg:g")

# let us store some states -- should we use these?
d3.json "/json/us-states.json", (json) ->
  states = json

# and we shall store some bases, yes we shall
d3.json "/json/bases_districts.json", (json) ->
  demographics = json

d3.json "/json/district_to_member.json", (json) ->
  members = json

# let us load saipe data
#d3.json "../static/data/saipehighlights.json", (json) ->
#  saipehighlights = json

# get district name
getDistrictName = (d) ->
  d.properties.d_name

# draw the spark in the upper right (yes, not such a spark now)
drawSpark = ->
  if selectedDistrict or currentDistrict
    spark.style "visibility", "visible"
    districtName.style "visibility", "visible"
    districtPic.style "visibility", "visible"
    geographyPic.style "visibility", "visible"
    unemployment.style "visibility", "visible"
    percent_military.style "visibility", "visible"
    name = undefined
    if selectedDistrict
      name = getDistrictName(selectedDistrict.__data__)
    else
      name = getDistrictName(currentDistrict)
    districtName.text(members[name]['member_name'])
    districtPic.attr("xlink:href","/images/" + members[name]['member_id'] + "-100px.jpeg")
    geographyPic.attr("xlink:href","/images/district_photos/" + name + ".jpg")
    i = 0
    display base for base in demographics[name].bases if demographics[name].bases
    unemployment.text(demographics[name].unemployment_percent_10 + "% unemployment (was " + demographics[name].unemployment_percent_09 + "%)");
    percent_military.text(demographics[name].percent_military_employment_10 + "% military (was " + demographics[name].percent_military_employment_09 + "%)");
    #percent_military_employment_09
  else
    spark.style "visibility", "hidden"
    districtName.style "visibility", "hidden"
    unemployment.style "visibility", "hidden"
    percent_military.style "visibility", "hidden"
    districtPic.style "visibility", "hidden"
    geographyPic.style "visibility", "hidden"
    districtBases.selectAll(".a_base").remove()

display = (base) ->
  i = i + 20
  districtBases.append("svg:text").attr("class", "a_base").attr("transform", "translate(15, "+ (300 + i) + ")").text(base);

drawMap = ->
  # we fill in all the path elements
  #map.selectAll("path").attr("class", quantize)
  map.selectAll("path").attr("class", quantize_by_military)

#########################################################################
#                         Here it the big deal
#########################################################################
d3.json "/json/short_districts.json", (json) ->
  features = []
  i = 0
  while i < json.features.length
    feature = json.features[i]
    features.push feature if feature.properties # let's exclude puerto-rico here . . .
    i++
  # ensure a click resets things
  svg.on "click", (d,i) ->
    # basically, a reset
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

quantize = (d) ->
  "q" + Math.min(8, d.properties.color_index) + "-9"

quantize_by_military = (d) ->
  #console.log(d.properties.d_name);
  console.log( ~~(demographics[d.properties.d_name].percent_military_employment_10 * 2/8));
  "q" + Math.min(8, ~~(demographics[d.properties.d_name].percent_military_employment_10 * 2/8)) + "-9"

# do we want notes?
drawTitleAndMisc = ->
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 715)").attr("text-anchor", "end").text "By: TIM BOOHER AND JOHN SWISHER | March 2012"
  svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 730)").attr("text-anchor", "end").text "Data: MPES Database, Small Area Income & Poverty Estimates, U.S. Census Bureau"
