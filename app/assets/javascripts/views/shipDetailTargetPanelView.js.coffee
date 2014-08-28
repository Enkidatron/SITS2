SitsApp.Views.ShipDetailTargetPanelView = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, "change", this.render)
		this.bindTo(this.model.targets, "add", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	events:
		'click #start': 'setTargetingPhaseStart'
		'click #midpoint': 'setTargetingPhaseMidpoint'
		'click #endpoint': 'setTargetingPhaseEndpoint'
	setTargetingPhaseStart: ->
		this.model.setTargetingPhase('start')
	setTargetingPhaseMidpoint: ->
		this.model.setTargetingPhase('midpoint')
	setTargetingPhaseEndpoint: ->
		this.model.setTargetingPhase('endpoint')
	render: ->
		this.$el.html(JST['ships/targetPanel']({model: this.model}))
		targetlistView = new SitsApp.Views.ShipDetailTargetlistView({collection: this.model.targets})
		this.$('#target-table-area').html(targetlistView.render().el)
		return this
)

_.extend(SitsApp.Views.ShipDetailTargetPanelView.prototype, Observer)