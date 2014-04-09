SitsApp.Views.ShipsIndex = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.collection, "change", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	render: ->
		self = this
		this.$el.html(JST['ships/index']())
		this.collection.each( (ship) ->
			shipNavView = new SitsApp.Views.ShipNavView({ model: ship, className: "btn-group" })
			self.$('#shipListToolbar').append(shipNavView.render().el)
			)
		return this
	)

_.extend(SitsApp.Views.ShipsIndex.prototype, Observer)