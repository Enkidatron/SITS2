SitsApp.Models.ShipDetail = Backbone.Model.extend(
	initialize: ->
		this.ensureTargetCollection()
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
	setTargetingPhase: (phase) ->
		this.set({'targetingPhase':phase})
	getTargetingPhase: ->
		return this.get('targetingPhase')
	getTargetingPhaseOrientation: ->
		phase = this.get('targetingPhase')
		if phase == 'start' and this.startIntegrity()
			return [this.get('startFront'),this.get('startTop')]
		else if phase == 'midpoint' and this.midIntegrity()
			return [this.get('midFront'), this.get('midTop')]
		else if phase == 'endpoint' and this.endIntegrity()
			return [this.get('endFront'), this.get('endTop')]
	getLegalValues: (bearing) ->
		switch bearing
			when 'startFront'
				pair = 'startTop'
				sideways = [['midFront',Math.ceil(this.get('pivot')/2)],['endFront',this.get('pivot')]]
				filter = true
			when 'startTop'
				pair = 'startFront'
				sideways = [['midTop',Math.ceil(this.get('roll')/2)],['endTop',this.get('roll')]]
				filter = false
			when 'midFront'
				pair = 'midTop'
				sideways = [['startFront',Math.ceil(this.get('pivot')/2)],['endFront',Math.ceil(this.get('pivot')/2)]]
				filter = true
			when 'midTop'
				pair = 'midFront'
				sideways = [['startTop',Math.ceil(this.get('roll')/2)],['endTop',Math.ceil(this.get('roll')/2)]]
				filter = false
			when 'endFront'
				pair = 'endTop'
				sideways = [['startFront',this.get('pivot')],['midFront',Math.ceil(this.get('pivot')/2)]]
				filter = true
			when 'endTop'
				pair = 'endFront'
				sideways = [['startTop',this.get('roll')],['midTop',Math.ceil(this.get('roll')/2)]]
				filter = false
		if this.get(pair)?
			legalValues = SitsApp.ShipCalculator._getAdjustedWindowMetaChart(this.get(pair))[3]
		for s in [0..1]	
			if this.get(sideways[s][0])?
				sidewaysValues = []
				chart = SitsApp.ShipCalculator._getAdjustedWindowMetaChart(this.get(sideways[s][0]))
				for i in [sideways[s][1]..0]
					sidewaysValues = _.union(sidewaysValues,chart[i])
				legalValues ?= sidewaysValues
				legalValues = _.intersection(legalValues,sidewaysValues)
		legalValues ?= []
		if filter
			lineValues = ['ab++','bc++','cd++','de++','ef++','fa++','ab--','bc--','cd--','de--','ef--','fa--']
			legalValues = _.difference(legalValues,lineValues)
		return legalValues
		
	ensureTargetCollection: ->
		this.targets ?= new SitsApp.Collections.ShipDetailTargets()
		this.targets.setParent(this)
	save: (attrs, options) ->
		options ?= {}
		# filter down to acceptable attributes
		whitelist = ['id','name','pivot','roll','notes','startFront','startTop','midFront','midTop','endFront','endTop']
		if attrs?
			attrs = _.pick(attrs,whitelist)
			options.data = JSON.stringify(attrs)
		# Call the original save function
		Backbone.Model.prototype.save.call(this,attrs,options)
)