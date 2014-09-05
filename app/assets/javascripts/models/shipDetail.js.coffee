SitsApp.Models.ShipDetail = Backbone.Model.extend(
	initialize: ->
		this.ensureTargetCollection()
	urlRoot: '/ships/detail/'
	isPresent: (bearing) ->
		return this.get(bearing)? and this.get(bearing) != ''
	startMidFront: ->
		if this.isPresent('startFront') and this.isPresent('midFront') and this.isPresent('pivot')
			if SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startFront'), this.get('midFront'), Math.ceil(this.get('pivot')/2))
				return 1
			else 
				return 0
		else
			return 2
	midEndFront: ->
		if this.isPresent('midFront') and this.isPresent('endFront') and this.isPresent('pivot')
			if SitsApp.ShipCalculator.verifyNavigationSegment(this.get('midFront'), this.get('endFront'), Math.ceil(this.get('pivot')/2))
				return 1
			else 
				return 0
		else
			return 2
	startEndFront: ->
		if this.isPresent('startFront') and this.isPresent('endFront') and this.isPresent('pivot')
			answer = SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startFront'), this.get('endFront'), Math.ceil(this.get('pivot')))
			if answer and this.isPresent('midFront')
				answer = SitsApp.ShipCalculator.getTotalPathDistance(this.get('startFront'), this.get('midFront'), this.get('endFront')) <= this.get('pivot')
			if answer
				return 1
			else
				return 0
		else
			return 2
	startMidTop: ->
		if this.isPresent('startTop') and this.isPresent('midTop') and this.isPresent('roll')
			if SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startTop'), this.get('midTop'), Math.ceil(this.get('roll')/2))
				return 1
			else 
				return 0
		else
			return 2
	midEndTop: ->
		if this.isPresent('midTop') and this.isPresent('endTop') and this.isPresent('roll')
			if SitsApp.ShipCalculator.verifyNavigationSegment(this.get('midTop'), this.get('endTop'), Math.ceil(this.get('roll')/2))
				return 1
			else 
				return 0
		else
			return 2
	startEndTop: ->
		if this.isPresent('startTop') and this.isPresent('endTop') and this.isPresent('roll')
			answer = SitsApp.ShipCalculator.verifyNavigationSegment(this.get('startTop'), this.get('endTop'), Math.ceil(this.get('roll')))
			if answer and this.isPresent('midTop')
				answer = SitsApp.ShipCalculator.getTotalPathDistance(this.get('startTop'), this.get('midTop'), this.get('endTop')) <= this.get('pivot')
			if answer
				return 1
			else
				return 0
		else
			return 2
	startIntegrity: ->
		if this.isPresent('startFront') and this.isPresent('startTop')
			if SitsApp.ShipCalculator.verifyIntegrity(this.get('startFront'), this.get('startTop'))
				return 1
			else 
				return 0
		else
			return 2
	midIntegrity: ->
		if this.isPresent('midFront') and this.isPresent('midTop')
			if SitsApp.ShipCalculator.verifyIntegrity(this.get('midFront'), this.get('midTop'))
				return 1
			else 
				return 0
		else
			return 2
	endIntegrity: ->
		if this.isPresent('endFront') and this.isPresent('endTop')
			if SitsApp.ShipCalculator.verifyIntegrity(this.get('endFront'), this.get('endTop'))
				return 1
			else 
				return 0
		else
			return 2
	setbearing: (bearing, value) ->
		if value == '' or SitsApp.ShipCalculator.verifyBearing(value)
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
		if this.get(pair)? and this.get(pair) != ''
			legalValues = _.intersection(SitsApp.ShipCalculator._getAdjustedWindowMetaChart(this.get(pair))[3], SitsApp.ShipCalculator._getAdjustedWindowMetaChart(SitsApp.ShipCalculator._invertBearing(this.get(pair)))[3])
		for s in [0..1]	
			if this.get(sideways[s][0])? and this.get(sideways[s][0]) != ''
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