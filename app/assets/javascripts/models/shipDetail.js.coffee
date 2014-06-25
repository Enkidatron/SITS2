SitsApp.Models.ShipDetail = Backbone.Model.extend(
	urlRoot: '/ships/detail/'
	startMidFront: ->
		if this.get('startFront')? and this.get('midFront')? and this.get('pivot')?
			return SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startFront'), this.get('midFront'), Math.ceil(this.get('pivot')/2))
		else
			return false
	midEndFront: ->
		if this.get('midFront')? and this.get('endFront')? and this.get('pivot')?
			return SitsApp.ShipCalculator.verifyNavigationSegment(this.get('midFront'), this.get('endFront'), Math.ceil(this.get('pivot')/2))
		else
			return false
	startEndFront: ->
		if this.get('startFront')? and this.get('endFront')? and this.get('pivot')?
			answer = SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startFront'), this.get('endFront'), Math.ceil(this.get('pivot')))
			if answer and this.get('midFront')?
				answer = SitsApp.ShipCalculator.getTotalPathDistance(this.get('startFront'), this.get('midFront'), this.get('endFront')) <= this.get('pivot')
			return answer
		else
			return false
	startMidTop: ->
		if this.get('startTop')? and this.get('midTop')? and this.get('roll')?
			return SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startTop'), this.get('midTop'), Math.ceil(this.get('roll')/2))
		else
			return false
	midEndTop: ->
		if this.get('midTop')? and this.get('endTop')? and this.get('roll')?
			return SitsApp.ShipCalculator.verifyNavigationSegment(this.get('midTop'), this.get('endTop'), Math.ceil(this.get('roll')/2))
		else
			return false
	startEndTop: ->
		if this.get('startTop')? and this.get('endTop')? and this.get('roll')?
			answer = SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startTop'), this.get('endTop'), Math.ceil(this.get('roll')))
			if answer and this.get('midTop')?
				answer = SitsApp.ShipCalculator.getTotalPathDistance(this.get('startTop'), this.get('midTop'), this.get('endTop')) <= this.get('pivot')
			return answer
		else
			return false
	startIntegrity: ->
		if this.get('startFront')? and this.get('startTop')?
			return SitsApp.ShipCalculator.verifyIntegrity(this.get('startFront'), this.get('startTop'))
		else
			return false
	midIntegrity: ->
		if this.get('midFront')? and this.get('midTop')?
			return SitsApp.ShipCalculator.verifyIntegrity(this.get('midFront'), this.get('midTop'))
		else
			return false
	endIntegrity: ->
		if this.get('endFront')? and this.get('endTop')?
			return SitsApp.ShipCalculator.verifyIntegrity(this.get('endFront'), this.get('endTop'))
		else
			return false
	setbearing: (bearing, value) ->
		if SitsApp.ShipCalculator.verifyBearing(value)
			console.log("ShipDetail.setbearing: #{bearing}, #{value}")
			map = {}
			map[bearing] = value
			this.set(map)
			this.save()
)