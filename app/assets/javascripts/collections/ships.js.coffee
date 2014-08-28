SitsApp.Collections.Ships = Backbone.Collection.extend(
	model: SitsApp.Models.Ship
	url: '/ships'
	addShip: (ship) ->
		this.add(ship)
	refresh: ->
		this.fetch()
	)