SitsApp.Models.ShipDetail = Backbone.Model.extend(
	urlRoot: '/ships/detail/'
	startMidFront: ->
		true
	midEndFront: ->
		true
	startEndFront: ->
		true
	startMidTop: ->
		true
	midEndTop: ->
		true
	startEndTop: ->
		true
	setbearing: (bearing, value) ->
		console.log("ShipDetail.setbearing: #{bearing}, #{value}")
		map = {}
		map[bearing] = value
		this.set(map)
		this.save()
)