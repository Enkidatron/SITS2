SitsApp.Views.ShipDetailNavVerify = Backbone.View.extend(
	initialize: (options) ->
		this.options = options || {}
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, this.propertyUpdated, this.render)
		this.bindTo(this.model, this.propertyUpdatedTwo, this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	render: ->
		this.$el.html(JST['ships/navPanelVerify']({ model: this.model, segment: this.options.segment }))
		return this
)

_.extend(SitsApp.Views.ShipDetailNavVerify.prototype, Observer)