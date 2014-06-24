SitsApp.Views.ShipsIndex = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.collection, "change", this.render)
		this.bindTo(this.collection, "sync", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	events: 
		"click#delete": "refresh"
	render: ->
		self = this
		this.$el.html(JST['ships/index']())
		this.collection.each( (ship) ->
			shipNavView = new SitsApp.Views.ShipNavView({ model: ship, className: "btn-group" })
			self.$('#shipListToolbar').append(shipNavView.render().el)
			)
		newShip = new SitsApp.Models.Ship()
		shipNewView = new SitsApp.Views.ShipNewView({ model: newShip, className: "pull-right"})
		self.$('#shipListToolbar').append(shipNewView.render().el)
		return this
	refresh: ->
		this.collection.refresh()
	)

_.extend(SitsApp.Views.ShipsIndex.prototype, Observer)