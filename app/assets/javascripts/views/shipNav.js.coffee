SitsApp.Views.ShipNavView = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "change", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	render: ->
		this.$el.html(JST['ships/shipNav']({ model: this.model }))
		return this
	)

_.extend(SitsApp.Views.ShipNavView.prototype, Observer)