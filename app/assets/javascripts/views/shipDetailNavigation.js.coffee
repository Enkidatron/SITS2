SitsApp.Views.ShipDetailNavigation = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, "change", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	addInputView: (element, propertyUpdated, bearing) ->
		InputView = new SitsApp.Views.ShipDetailNavInput({model: this.model, propertyUpdated: propertyUpdated, bearing: bearing})
		this.$(element).append(InputView.render().el)
	addVerifyView: (element, propertyUpdated, propertyUpdatedTwo, segment) ->
		VerifyView = new SitsApp.Views.ShipDetailNavVerify({model: this.model, propertyUpdated: propertyUpdated, propertyUpdatedTwo: propertyUpdatedTwo, segment: segment})
		this.$(element).append(VerifyView.render().el)
	render: ->
		# This is awful and should be changed to be more DRY (I can use acronyms too (ICUAT))
		this.$el.html(JST['ships/navPanel']({ model: this.model }))
		this.addInputView('#input-start-front', 'update-start-front', 'startFront')
		this.addInputView('#input-mid-front', 'update-mid-front', 'midFront')
		this.addInputView('#input-end-front', 'update-end-front', 'endFront')
		this.addInputView('#input-start-top', 'update-start-top', 'startTop')
		this.addInputView('#input-mid-top', 'update-mid-top', 'midTop')
		this.addInputView('#input-end-top', 'update-end-top', 'endTop')
		this.addVerifyView('#verify-start-mid-front', 'update-start-front', 'update-mid-front', 'startMidFront')
		this.addVerifyView('#verify-mid-end-front', 'update-mid-front', 'update-end-front', 'midEndFront')
		this.addVerifyView('#verify-start-end-front', 'update-start-front', 'update-end-front', 'startEndFront')
		this.addVerifyView('#verify-start-mid-top', 'update-start-top', 'update-mid-top', 'startMidTop')
		this.addVerifyView('#verify-mid-end-top', 'update-mid-top', 'update-end-top', 'midEndTop')
		this.addVerifyView('#verify-start-end-top', 'update-start-top', 'update-end-top', 'startEndTop')
		this.addVerifyView('#verify-start-integrity', 'update-start-front','update-start-top', 'startIntegrity')
		this.addVerifyView('#verify-mid-integrity', 'update-mid-front', 'update-mid-top', 'midIntegrity')
		this.addVerifyView('#verify-end-integrity', 'update-end-front', 'update-end-top', 'endIntegrity')
		return this
)

_.extend(SitsApp.Views.ShipDetailNavigation.prototype, Observer)