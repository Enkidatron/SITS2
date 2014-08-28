SitsApp.Models.ShipDetailTarget = Backbone.Model.extend(
	initialize: (parent) ->
		this.set({'parent': parent})
	schema:
		distance: 'Text'
	getBearing: ->
		if this.get('distance')?
			SitsApp.ShipCalculator.getBearingFromDistance(this.get('distance'))

	getAspect: ->
		if this.get('distance')?
			shipOrientation = this.get('parent').getTargetingPhaseOrientation()
			if shipOrientation?
				console.log(shipOrientation)
				return SitsApp.ShipCalculator.getAspect(shipOrientation,this.get('distance'))

	getRange: ->
		if this.get('distance')?
			SitsApp.ShipCalculator.getRangeFromDistance(this.get('distance'))
		
	setdistance: (value) ->
		if SitsApp.ShipCalculator.verifyDistance(value)
			this.set('distance', SitsApp.ShipCalculator.consolidateDistanceNotation(value))
)