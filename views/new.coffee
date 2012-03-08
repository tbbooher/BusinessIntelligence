(->
  #displayCurrentSettings = ->
  #  $("#controls-year .current").text years[currentYearIndex]
  sortNumberAscending = (a, b) ->
    a - b

  getFips = (d) ->
    d.properties.GEO_ID.substring 9, 14

  getCountyName = (d) ->
    county = d.properties.NAME + " County"
    state = states[d.properties.STATE][0]
    [ county, state ]

  # Federal Information Processing Standard
  getCountyByFips = (fips) ->
    map.selectAll("path")[0].filter((value, index, array) ->
      getFips(value.__data__) is fips
    )[0]

  # do we want notes?
  drawTitleAndMisc = ->
    svg.append("svg:text").attr("class", "year").attr("transform", "translate(15, 50)").text ""
    svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 715)").attr("text-anchor", "end").text "By: GABRIEL FLORIT | December 2011"
    svg.append("svg:text").attr("class", "notes").attr("transform", "translate(" + (950 + extraTranslateRight) + ", 730)").attr("text-anchor", "end").text "Data: Small Area Income & Poverty Estimates, U.S. Census Bureau"

  # legend
  drawLegend = ->
    legend.append("svg:text").attr("class", "legend-title").attr("x", -25).attr("y", -20).text "percent"
    legendGradient.selectAll("rect").data(d3.range(0, 1, 0.01)).enter().insert("svg:rect").attr("x", 1).attr("y", (d, i) ->
      i * 2
    ).attr("width", legendGradientWidth).attr("height", 2).style "fill", (d, i) ->
      d3.hsl hue, 1, d

    legendTicks.selectAll("text").data([ maxValue, minValue ]).enter().insert("svg:text").attr("class", "legend-tick").attr("text-anchor", "end").attr("x", -4).attr("y", (d, i) ->
      i * legendGradientHeight + 5
    ).text (d, i) ->
      d3.format(".0f")(d) + "%"

    legend.append("svg:rect").attr("y", 0).attr("x", 1).attr("width", legendGradientWidth).attr("height", legendGradientHeight).style("fill", "none").style("stroke", "#ccc").style "shape-rendering", "crispEdges"

  # percent to color
  convertPercentToColor = (percent) ->
    (if percent then d3.hsl(hue, 1, 1 - continuousScale(percent)) else noData)

  quantize = (d) ->
    fips = getFips(d)
    datum = data[years[currentYearIndex]][fips]
    (if datum then convertPercentToColor(datum) else noData)

  drawMap = ->
    svg.select(".year").text years[currentYearIndex]
    map.selectAll("path").style "fill", quantize
    displayCurrentSettings()

  eraseLegend = ->
    legend.selectAll("text").remove()
    legendGradient.selectAll("rect").remove()
    legendTicks.selectAll("text").remove()

  drawMapAndLegend = ->
    eraseLegend()
    drawLegend()
    drawMap()

  # define a bunch of variables
  data = undefined
  svg = undefined
  minValue = undefined
  maxValue = undefined
  legend = undefined
  legendGradient = undefined
  legendTicks = undefined
  map = undefined
  continuousScale = undefined
  currentCounty = undefined
  selectedCounty = undefined
  states = undefined
  topFiveData = undefined
  saipehighlights = undefined
  spark = undefined
  sparkx = undefined
  sparky = undefined
  sparkline = undefined
  sparkLineWidth = 220
  sparkLineHeight = 150
  legendGradientWidth = 30
  legendGradientHeight = 200
  extraTranslateRight = 100
  years = []
  noData = "rgb(255,255,255)"
  highlightColor = d3.rgb(198, 42, 42)
  highlightColor = d3.rgb("red").darker()
  currentYearIndex = 0
  hue = 230

  #basic graphics manipulation (we need to do)
  path = d3.geo.path()
  svg = d3.select("#chart").append("svg:svg")
  legend = svg.append("svg:g").attr("transform", "translate(" + (904 + extraTranslateRight) + ", 240)")
  legendGradient = legend.append("svg:g")
  legendTicks = legend.append("svg:g")
  map = svg.append("svg:g").attr("class", "map").attr("transform", "translate(" + (extraTranslateRight + 50) + ", 0)")
  spark = svg.append("svg:g").attr("class", "spark").attr("transform", "translate(55, 230)").style("visibility", "hidden")
  countyName = svg.append("svg:g").attr("class", "countyName").attr("transform", "translate(15, 260)").style("visibility", "hidden")

  # load states data
  d3.json "../static/data/states.json", (json) ->
    states = json

  # load saipe data
  d3.json "../static/data/saipehighlights.json", (json) ->
    saipehighlights = json

  # load counties and create click events
  # this is what we need to duplicate
  d3.json "../static/geojson/counties.json", (json) ->
    features = []
    i = 0

    while i < json.features.length
      feature = json.features[i]
      features.push feature  if feature.properties and feature.properties.STATE and feature.properties.STATE <= 56
      i++
    svg.on "click", (d, i) ->
      if selectedCounty
        d3.select(selectedCounty).style "fill", convertPercentToColor(data[years[currentYearIndex]][getFips(selectedCounty.__data__)])
        selectedCounty = null

    map.selectAll("path").data(features).enter().append("svg:path").attr("d", path).style("fill", noData).on("mouseover", (d) ->
      unless selectedCounty
        d3.select(this).style "fill", highlightColor
        currentCounty = d
        drawSpark()
    ).on("mouseout", (d) ->
      d3.select(this).style "fill", convertPercentToColor(data[years[currentYearIndex]][getFips(d)])  unless selectedCounty
      currentCounty = null
      drawSpark()
    ).on "click", (d, i) ->
      fips = getFips(d)
      topFiveCounties = topFiveData.filter((value, index, array) ->
        value.key is fips
      )
      if topFiveCounties.length > 0
        drawTopFiveInfoText saipehighlights[topFiveCounties[0].key]
      else
        drawTopFiveInfoText ""
      if selectedCounty
        if selectedCounty is this
          d3.select(selectedCounty).style "fill", convertPercentToColor(data[years[currentYearIndex]][getFips(selectedCounty.__data__)])
          selectedCounty = null
          drawTopFiveInfoText ""
        else
          d3.select(selectedCounty).style "fill", convertPercentToColor(data[years[currentYearIndex]][getFips(selectedCounty.__data__)])
          selectedCounty = this
          d3.select(selectedCounty).style "fill", highlightColor
          drawSpark()
      else
        selectedCounty = this
        d3.select(selectedCounty).style "fill", highlightColor
      d3.event.stopPropagation()

    # Model-based Small Area Income & Poverty Estimates (SAIPE) for School Districts, Counties, and States
    d3.json "../static/data/saipe.json", (saipe) ->
      for year of saipe
        years.push parseInt(year)
      years = years.sort(sortNumberAscending)
      data = saipe
      setTopFive()
      allYears = []
      i = 0

      while i < years.length
        yearValues = data[years[i]]
        allYears.push d3.values(yearValues)
        i++
      sortedValues = d3.merge(allYears).sort(sortNumberAscending)
      minValue = d3.min(sortedValues)
      maxValue = d3.max(sortedValues)
      continuousScale = d3.scale.linear().domain([ minValue, maxValue ]).range([ 0, 1 ])
      sparkx = d3.scale.linear().domain([ 0, years.length ]).range([ 0, sparkLineWidth ])
      sparky = d3.scale.linear().domain([ minValue, maxValue ]).range([ 0, -sparkLineHeight ])
      sparkline = d3.svg.line().x((d, i) ->
        sparkx i
      ).y((d) ->
        sparky (if d then d else minValue)
      )
      tempCounty = getCountyByFips(topFiveData[0].key).__data__
      fips = getFips(tempCounty)
      name = getCountyName(tempCounty)
      sparkdata = []
      i = 0

      while i < years.length
        datum = data[years[i]][fips]
        sparkdata.push datum
        i++
      topFiveInfo.append("foreignObject").attr("width", 770).attr("height", 500).append("xhtml:body").html("").on "click", (d) ->
        d3.event.stopPropagation()

      topFive.selectAll("text").data(topFiveData).enter().append("svg:image").attr("xlink:href", "../static/img/play_9x12.png").attr("width", 9).attr("height", 12).attr("x", 0).attr "y", (d, i) ->
        i * 25 - 11

      topFive.selectAll("text").data(topFiveData).enter().insert("svg:text").attr("x", 15).attr("y", (d, i) ->
        i * 25
      ).text((d, i) ->
        county = getCountyByFips(d.key)
        county.__data__.properties.NAME + ", " + states[county.__data__.properties.STATE][1] + ": " + d3.format(".1f")(d.value) + "%"
      ).on("mouseover", (d) ->
        county = getCountyByFips(d.key)
        unless county is selectedCounty
          d3.select(county).style "fill", highlightColor
          currentCounty = county.__data__
          drawSpark()
      ).on("mouseout", (d) ->
        county = getCountyByFips(d.key)
        unless county is selectedCounty
          d3.select(county).style "fill", convertPercentToColor(d.value)
          currentCounty = null
          drawSpark()
      ).on "click", (d, i) ->
        currentCounty = null
        county = getCountyByFips(d.key)
        unless county is selectedCounty
          d3.select(selectedCounty).style "fill", convertPercentToColor(data[years[currentYearIndex]][getFips(selectedCounty.__data__)])  if selectedCounty
          selectedCounty = county
          drawSpark()
          drawTopFiveInfoText saipehighlights[d.key]
        d3.event.stopPropagation()

      spark.append("svg:path").attr "d", sparkline(sparkdata)
      spark.selectAll("text").data([ sparkdata[0], sparkdata[sparkdata.length - 1], sparkdata[currentYearIndex] ]).enter().insert("svg:text").attr("text-anchor", (d, i) ->
        switch i
          when 0
            return "end"
          when 1
            return "start"
          when 2
            return "middle"
      ).attr("x", (d, i) ->
        (if i < 2 then i * (sparkLineWidth - 22) - 8 else sparkx(currentYearIndex))
      ).attr("y", (d, i) ->
        (if i < 2 then sparky(d) + 5 else sparky(d) - 10)
      ).text (d, i) ->
        (if i < 2 then d3.format(".1f")(d) else (if currentYearIndex > 0 and currentYearIndex < years.length - 1 then d3.format(".1f")(d) else ""))

      spark.selectAll("circle").data([ sparkdata[currentYearIndex] ]).enter().insert("svg:circle").attr("cx", (d, i) ->
        sparkx currentYearIndex
      ).attr("cy", (d, i) ->
        sparky d
      ).attr "r", 5
      countyName.selectAll("text").data(name).enter().insert("svg:text").attr("class", (d, i) ->
        (if i is 0 then "county" else "state")
      ).attr("y", (d, i) ->
        i * 25
      ).text (d, i) ->
        d

      drawTitleAndMisc()
      setTimeout (->
        drawMapAndLegend()
        $("#controls").show()
        $("#about").show()
        $("#loading").hide()
      ), 500

)()