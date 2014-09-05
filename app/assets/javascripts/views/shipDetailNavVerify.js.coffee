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
		answer = this.model[this.options.segment]()
		if answer == 1
			label = 'success'
			word = 'Good!'
		else if answer == 2
			label = 'warning'
			word = 'Not Set'
		else
			label = 'danger'
			word = 'Not Good!'
		this.$el.html(JST['ships/navPanelVerify']({ model: {label: label, word: word} }))
		return this
)

_.extend(SitsApp.Views.ShipDetailNavVerify.prototype, Observer)