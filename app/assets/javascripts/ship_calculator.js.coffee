SitsApp.ShipCalculator =  
	# public
	verifyNavigationSegment: (rawFront, rawTop, maneuver) -> 
		if this._getDistanceBetweenRawBearings(rawFront, rawTop) <= maneuver
			return true
		else
			return false

	verifyIntegrity: (rawFront, rawTop) ->
		chart = this._getAdjustedWindowMetaChart(rawFront)[3]
		return (rawTop in chart and this._invertBearing(rawTop) in chart)

	verifyBearing: (rawText) ->
		re = /^[a-f]{0,2}[+-]{0,3}$/i
		return re.test(rawText) and rawText.length <= 4

	getTotalPathDistance: (rawFirst, rawSecond, rawThird) ->
		return this._getDistanceBetweenRawBearings(rawFirst,rawSecond) + this._getDistanceBetweenRawBearings(rawSecond, rawThird)

	verifyDistance: (rawText) ->
		re = /^([a-f+-]\d+)+$/i
		return re.test(rawText)

	consolidateDistanceNotation: (validText) ->
		components = this._getDistanceComponents(validText)
		components = this._mergeAdjacentDistanceComponents(components)
		components = this._pairwiseEliminateDistanceComponents(components)
		# filter components for truth-y values?
		return this._distanceComponentsToString(components)

	getBearingFromDistance: (distanceText) ->
		components = this._getDistanceComponents(distanceText)
		ring = this._getRingFromDistance(components)
		switch ring.length
			when 0,1
				direction = this._getFlatDirectionFromDistance(components)
			when 2
				direction = this._getElevatedDirectionFromDistance(components)
			when 3
				direction = ''
		return "#{direction}#{ring}"

	getAspect: (orientation, distanceText) ->
		target = this.getBearingFromDistance(distanceText)
		front = orientation[0]
		top = orientation[1]
		starboard = this._getStarboard(front,top)
		aft = this._invertBearing(front)
		bottom = this._invertBearing(top)
		port = this._invertBearing(starboard)
		distances = _.map([[front,'front'],[top,'top'],[starboard,'starboard'],[aft,'aft'],[bottom,'bottom'],[port,'port']], this._createGetWindowDistance(target))
		distances.sort (a,b) ->
			if a[1] != b[1]
				return if a[1] > b[1] then 1 else -1
			else
				priority = ['front','aft','starboard','port','top','bottom']
				return if priority.indexOf(a[0]) < priority.indexOf(b[0]) then 1 else -1
		console.log(distances)
		tie = if (distances[1][1] == distances[2][1]) then true else false
		answer = ''
		switch distances[0][0]
			when 'starboard'
				answer = 'Starboard Broadside'
			when 'port'
				answer = 'Port Broadside'
			when 'top'
				answer = 'Top Wedge'
				switch distances[1][0]
					when 'front'
						answer += ', leak to Fore'
					when 'aft'
						answer += ', leak to Aft'
					when 'starboard'
						answer += ', leak to Starboard'
					when 'port'
						answer += ', leak to Port'
			when 'bottom'
				answer = 'Bottom Wedge'
				switch distances[1][0]
					when 'front'
						answer += ', leak to Fore'
					when 'aft'
						answer += ', leak to Aft'
					when 'starboard'
						answer += ', leak to Starboard'
					when 'port'
						answer += ', leak to Port'
			when 'front'
				answer = 'Fore'
				if distances[0][1] == 0
					answer += ', Unprotected'
				else
					switch distances[1][0]
						when 'top','bottom'
							answer += ', Unprotected'
						when 'starboard'
							answer += ', Starboard Sidewall'
						when 'port'
							answer += ', Port Sidewall'
			when 'aft'
				if distances[0][1] == 0
					answer = 'Aft, Unprotected'
				else
					switch distances[1][0]
						when 'top'
							answer = 'Top Wedge, leak to Aft'
						when 'bottom'
							answer = 'Bottom Wedge, leak to Aft'
						when 'starboard'
							if tie
								switch distances[2][0]
									when 'top'
										answer = 'Top Wedge, leak to Aft, Starboard Sidewall'
									when 'bottom'
										answer = 'Bottom Wedge, leak to Aft, Starboard Sidewall'
							else
								answer = 'Aft, Starboard Sidewall'
						when 'port'
							if tie
								switch distances[2][0]
									when 'top'
										answer = 'Top Wedge, leak to Aft, Port Sidewall'
									when 'bottom'
										answer = 'Bottom Wedge, leak to Aft, Port Sidewall'
							else
								answer = 'Aft, Port Sidewall'
		return answer

	getRangeFromDistance: (distanceText) ->
		components = this._getDistanceComponents(distanceText)
		horizontal = this._getHorizontalRangeFromDistance(components)
		vertical = this._getVerticalRangeFromDistance(components)
		return Math.floor(Math.sqrt((horizontal*horizontal)+(vertical*vertical)))

	# first order private functions
	_getDistanceBetweenRawBearings: (rawFirst, rawSecond) ->
		adjustedBearings = this._getAdjustedBearings(rawFirst, rawSecond)
		distanceChart = this._getDistanceChart(adjustedBearings[0])
		return distanceChart[this._bearingToChartIndex(adjustedBearings[1])]

	_getAdjustedWindowMetaChart: (rawBearing) ->
		invert = false
		if rawBearing[-1..] == '-'
			rawBearing = this._invertBearing(rawBearing)
			invert = true
		orange = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		bearing = this._splitBearing(rawBearing)
		offset = orange.indexOf(bearing.letters)
		if offset == -1 then offset = 0
		origin = this._adjustBearing(rawBearing, offset)
		rawMetaChart = this._getWindowMetaChart(origin)
		adjustedMetaChart = for distance, windowChart of rawMetaChart
			(if invert then this._invertBearing(this._adjustBearing(bearing,12-offset)) else this._adjustBearing(bearing, 12-offset)) for bearing in windowChart

	_getDistanceComponents: (validText) ->
		firstSplit = validText.match(/[a-f+-]\d+/ig)
		secondSplit = (this._splitDistanceComponentText(textVector) for textVector in firstSplit)
		components = this._objectifyDistanceComponentArray(secondSplit)
		return components

	_mergeAdjacentDistanceComponents: (components) ->
		directions = ['a','b','c','d','e','f']
		(components = this._mergeSingleDistanceComponent(components,dir,i,directions)) for dir, i in directions
		return components

	_pairwiseEliminateDistanceComponents: (components) ->
		directionpairs = [['a','d'],['b','e'],['c','f'],['+','-']]
		(components = this._pairwiseEliminateSingleDistanceComponent(components,pair)) for pair in directionpairs
		return components

	_distanceComponentsToString: (components) ->
		directions = ['a','b','c','d','e','f','+','-']
		answer = ''
		(answer += this._getStringOfComponent(components,dir)) for dir in directions
		return answer

	_getRingFromDistance: (components) ->
		horizontal = this._getHorizontalRangeFromDistance(components)
		vertical = this._getVerticalRangeFromDistance(components)
		if vertical > horizontal * 5
			if components['+'] > 0
				return '+++'
			else
				return '---'
		else if vertical > horizontal
			if components['+'] > 0
				return '++'
			else
				return '--'
		else if vertical * 5 > horizontal
			if components['+'] >0
				return '+'
			else
				return '-'
		else
			return ''

	_getFlatDirectionFromDistance: (components) ->
		flatarray = ([key, value] for key, value of components when key in ['a','b','c','d','e','f'])
		flatarray.sort (a,b) -> 
			return if a[1] > b[1] then -1 else 1
		if flatarray[0][1] >= (flatarray[1][1] or 0) * 3
			return flatarray[0][0]
		else
			both = [flatarray[0][0],flatarray[1][0]]
			both.sort (a,b) ->
				return if a > b then 1 else -1
			return "#{both[0]}#{both[1]}"

	_getElevatedDirectionFromDistance: (components) ->
		flatarray = ([key, value] for key, value of components when key in ['a','b','c','d','e','f'])
		flatarray.sort (a,b) -> 
			return if a[1] > b[1] then -1 else 1
		return flatarray[0][0]

	_getStarboard: (front, top) ->
		chart = _.intersection((this._getAdjustedWindowMetaChart(front))[3], (this._getAdjustedWindowMetaChart(this._invertBearing(front)))[3])
		return chart[(chart.indexOf(top) + 3) % 12]

	_createGetWindowDistance: (target) ->
		self = this
		getWindowDistance = (source) ->
			adjusted = self._getAdjustedBearings(target, source[0])
			return [source[1], self._getDistanceChart(adjusted[0])[self._bearingToChartIndex(adjusted[1])]]
		return getWindowDistance

	_compareDistanceTuple: (a,b) ->
		if a[1] != b[1]
			return if a[1] > b[1] then 1 else -1
		else
			priority = ['front','aft','starboard','port','top','bottom']
			return if priority.indexOf(a[0]) < priority.indexOf(b[0]) then 1 else -1
			
	# second order private functions - bearing manipulation
	_getAdjustedBearings: (rawFirst, rawSecond) ->
		if rawFirst[-1..] == '-'
			rawFirst = this._invertBearing(rawFirst)
			rawSecond = this._invertBearing(rawSecond)
		first = this._splitBearing(rawFirst)
		switch first.symbols
			when '+++','---' then return [rawFirst,rawSecond]
			when '++','+','','-','--'
				offset = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa'].indexOf(first.letters)
				if offset % 2 == 1 then offset -= 1 
				return [this._adjustBearing(rawFirst, offset), this._adjustBearing(rawSecond, offset)]

	_invertBearing: (rawBearing) ->
		bearing = this._splitBearing(rawBearing)
		bearing.symbols = bearing.symbols.replace(/-/g, '_')
		bearing.symbols = bearing.symbols.replace(/\+/g, '-')
		bearing.symbols = bearing.symbols.replace(/_/g, '+')
		orange = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		index = orange.indexOf(bearing.letters)
		if index >= 0 then bearing.letters = orange[(index+6) % 12]
		bearing.letters ?= ''
		return bearing.letters.concat(bearing.symbols)

	_splitBearing: (rawBearing) ->
		breakpoint = rawBearing.search(/[+-]/)
		if breakpoint == -1
			answer = 
				letters: rawBearing
				symbols: ''
		else if breakpoint == 0
			answer = 
				letters: ''
				symbols: rawBearing
		else
			answer = 
				letters: rawBearing[...breakpoint]
				symbols: rawBearing[breakpoint...]
		return answer

	_adjustBearing: (rawBearing, offset) ->
		ring = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		bearing = this._splitBearing(rawBearing)
		switch bearing.symbols
			when '+++','---'
				answer = rawBearing
			else
				index = (ring.indexOf(bearing.letters) - offset + 12) % 12
				answer = ring[index].concat(bearing.symbols)
		return answer

	# second order private functions - distance manipulation
	_splitDistanceComponentText: (textVector) ->
		return [textVector[0],Number(textVector[1..])]

	_objectifyDistanceComponentArray: (vectorArray) ->
		answer = 
			'a': 0
			'b': 0
			'c': 0
			'd': 0
			'e': 0
			'f': 0
			'+': 0
			'-': 0
		(answer[arr[0]] = arr[1]) for arr in vectorArray
		return answer

	_mergeSingleDistanceComponent: (components, dir, i, directions) ->
		lesserNeighbor = Math.min.apply(null,[components[directions[(i-1+directions.length)%directions.length]],components[directions[(i+1)%directions.length]]])
		components[directions[(i-1+directions.length)%directions.length]] -= lesserNeighbor
		components[directions[i]] += lesserNeighbor
		components[directions[(i+1)%directions.length]] -= lesserNeighbor
		return components

	_pairwiseEliminateSingleDistanceComponent: (components, pair) ->
		lesserValue = Math.min.apply(null,[components[pair[0]],components[pair[1]]])
		components[pair[0]] -= lesserValue
		components[pair[1]] -= lesserValue
		return components

	_getStringOfComponent: (components, dir) ->
		if components[dir]? and components[dir] > 0
			return dir + components[dir]
		else
			return ''

	_getHorizontalRangeFromDistance: (components) ->
		answer = 0
		answer += components[dir] for dir in ['a','b','c','d','e','f']
		return answer

	_getVerticalRangeFromDistance: (components) ->
		answer = 0
		answer += components[dir] for dir in ['+','-']
		return answer

	# second order private functions - chart manipulation
	_getDistanceChart: (adjustedBearing) ->
		switch adjustedBearing
  		# 			 | |   green   |         blue          |         orange        |        low blue       | low green | |grn line hi|grn line lo|
			when 'a'
				return [3,2,2,3,4,3,2,1,1,2,3,4,4,5,4,4,3,2,1,0,1,2,3,4,5,6,5,4,3,2,1,1,1,2,3,4,4,5,4,4,3,2,1,2,2,3,4,3,2,3,2,3,4,4,3,2,2,3,4,4,3,2]
			when 'ab'
				return [3,2,2,3,4,4,3,1,1,1,2,3,4,5,5,5,4,3,2,1,0,1,2,3,4,5,6,5,4,3,2,1,1,1,2,3,4,5,5,5,4,3,2,2,2,3,4,4,3,3,2,3,4,4,4,3,2,3,4,4,4,3]
			when 'a+'
				return [2,1,2,3,3,3,2,0,1,2,3,4,4,4,4,4,3,2,1,1,1,2,3,4,5,5,5,4,3,2,1,2,2,3,4,5,5,6,5,5,4,3,2,3,3,4,5,4,3,4,2,3,3,3,3,2,3,4,5,5,4,3]
			when 'ab+'
				return [2,1,1,2,3,3,2,1,0,1,2,3,3,4,4,4,3,3,2,1,1,1,2,3,4,4,5,4,4,3,2,2,2,2,3,4,5,5,6,5,5,4,3,3,3,4,5,5,4,4,1,2,3,3,3,2,3,4,5,5,5,4]
			when 'a++'
				return [1,0,1,2,2,2,1,1,1,2,2,3,3,3,3,3,2,2,1,2,2,2,3,3,4,4,4,3,3,2,2,3,3,3,4,4,5,5,5,4,4,3,3,4,4,5,6,5,4,5,1,2,2,2,2,1,4,5,6,6,5,4]
			when '+++'
				return [0,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,6,1,1,1,1,1,1,5,5,5,5,5,5]
			when 'ab++'
				return [1,1,1,2,2,2,2,2,1,2,2,3,3,3,3,3,3,3,2,2,2,2,3,3,4,4,4,4,4,3,3,3,3,3,4,4,5,5,5,5,5,4,4,4,4,5,6,6,5,5,0,2,2,2,2,2,4,5,6,6,6,5]
	
	_bearingToChartIndex: (rawBearing) ->
		unwrap_table = ['+++','a++','b++','c++','d++','e++','f++','a+','ab+','b+','bc+','c+','cd+','d+','de+','e+','ef+','f+','fa+','a','ab','b','bc','c','cd','d','de','e','ef','f','fa','a-','ab-','b-','bc-','c-','cd-','d-','de-','e-','ef-','f-','fa-','a--','b--','c--','d--','e--','f--','---','ab++','bc++','cd++','de++','ef++','fa++','ab--','bc--','cd--','de--','ef--','fa--']
		return unwrap_table.indexOf(rawBearing)

	_getWindowMetaChart: (adjustedBearing) ->
		switch (adjustedBearing)
			when 'a'
				return {0: ['a'], 1: ['a+','ab+','ab','ab-','a-','fa-','fa','fa+'], 2: ['a++','ab++','b++','b+','b','b-','b--','ab--','a--','fa--','f--','f-','f','f+','f++','fa++'], 3: ['+++','c++','bc++','bc+','bc','bc-','bc--','c--','---','e--','ef--','ef-','ef','ef+','ef++','e++'], 4: ['d++','cd++','cd+','c+','c','c-','cd-','cd--','d--','de--','de-','e-','e','e+','de+','de++'], 5: ['d+','cd','d-','de'], 6: ['d']}
			when 'ab'
				return {0: ['ab'], 1: ['ab+','b+','b','b-','ab-','a-','a','a+'], 2: ['ab++','b++','bc+','bc','bc-','b--','ab--','a--','fa-','fa','fa+','a++'], 3: ['+++','bc++','c++','c+','c','c-','c--','bc--','---','fa--','f--','f-','f','f+','f++','fa++'], 4: ['de++','d++','cd++','cd+','cd','cd-','cd--','d--','de--','e--','ef--','ef-','ef','ef+','ef++','e++'], 5: ['de+','d+','d','d-','de-','e-','e','e+'], 6: ['de']}
			when 'a+'
				return {0: ['a+'], 1: ['a++','ab+','ab','a','fa','fa+'], 2: ['+++','ab++','b++','b+','b','ab-','a-','fa-','f','f+','f++','fa++'], 3: ['d++','cd++','c++','bc++','bc+','bc','b-','b--','ab--','a--','fa--','f--','f-','ef','ef+','ef++','e++','de++'], 4: ['d+','cd+','c+','c','bc-','bc--','c--','---','e--','ef--','ef-','e','e+','de+'], 5: ['d','cd','cd-','c-','cd--','d--','de--','e-','de-','de'], 6: ['d-']}
			when 'ab+'
				return {0: ['ab+'], 1: ['ab++','b++','b+','b','ab','a','a+','a++'], 2: ['+++','c++','bc++','bc+','bc','b-','ab-','a-','fa','fa+','fa++','f++'], 3: ['de++','d++','cd++','cd+','c+','c','bc-','b--','ab--','a--','fa-','f','f+','ef+','ef++','e++'], 4: ['de+','d+','d','cd','c-','c--','bc--','---','fa--','f--','f-','ef','e','e+'], 5: ['de','d-','cd-','cd--','d--','de--','e--','ef--','ef-','e-'], 6: ['de-']}
			when 'a++'
				return {0: ['a++'], 1: ['+++','b++','ab++','ab+','a+','fa+','fa++','f++'], 2: ['d++','cd++','c++','bc++','bc+','b+','b','ab','a','fa','f','f+','ef+','ef++','e++','de++'], 3: ['d+','cd+','c+','c','bc','b-','ab-','a-','fa-','f-','ef','e','e+','de+'], 4: ['d','cd','c-','bc-','b--','ab--','a--','fa--','f--','ef-','e-','de'], 5: ['d-','cd-','c--','bc--','---','ef--','e--','de-'], 6: ['d--','cd--','de--']}
			when '+++'
				return {0: ['+++'], 1: ['d++','cd++','c++','bc++','b++','ab++','a++','fa++','f++','ef++','e++','de++'], 2: ['d+','cd+','c+','bc+','b+','ab+','a+','fa+','f+','ef+','e+','de+'], 3: ['d','cd','c','bc','b','ab','a','fa','f','ef','e','de'], 4: ['d-','cd-','c-','bc-','b-','ab-','a-','fa-','f-','ef-','e-','de-'], 5: ['d--','cd--','c--','bc--','b--','ab--','a--','fa--','f--','ef--','e--','de--'], 6: ['---']}
			when 'ab++'
				return {0: ['ab++'], 1: ['+++','b++','ab+','a++'], 2: ['de++','d++','cd++','c++','bc++','bc+','b+','b','ab','a','a+','fa+','fa++','f++','ef++','e++'], 3: ['de+','d+','cd+','c+','c','bc','b-','ab-','a-','fa','f','f+','ef+','e+'], 4: ['de','d','cd','c-','bc-','b--','ab--','a--','fa-','f-','ef','e'], 5: ['de-','d-','cd-','c--','bc--','---','fa--','f--','ef-','e-'], 6: ['de--','d--','cd--','ef--','e--']}
