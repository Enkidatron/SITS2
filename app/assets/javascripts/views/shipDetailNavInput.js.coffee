SitsApp.Views.ShipDetailNavInput = Backbone.View.extend(
	initialize: (options) ->
		this.options = options || {}
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, this.options.propertyUpdated, this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	events:
		"hidden.bs.modal": "setbearing"
		"submit": "modalSubmit"
		"click #manual": "setManualForm"
		"click #legal": "setLegalForm"
	render: ->
		# console.log("ShipDetailNavInput.render: bearing: #{this.options.bearing} value: #{this.model.attributes[this.options.bearing]}")
		this.$el.html(JST['ships/navPanelInput'](
			model:
				bearing: this.model.attributes[this.options.bearing]
				propertyUpdated: this.options.propertyUpdated
				))
		this.form = new Backbone.Form(
			schema: 
				bearing: 'Text'
			data:
				bearing: this.model.get(this.options.bearing)
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
	modalSubmit: (e) ->
		e.preventDefault()
		this.$('.modal').modal('hide')
	setbearing: ->
		this.model.setbearing(this.options.bearing, this.form.getValue().bearing)
	setManualForm: ->
		this.form = new Backbone.Form(
			schema:
				bearing: 'Text'
			data:
				bearing: this.model.get(this.options.bearing)
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
	setLegalForm: ->
		this.form = new Backbone.Form(
			schema:
				bearing: 
					type: 'Select'
					options: this.model.getLegalValues(this.options.bearing)
			data:
				bearing: this.model.get(this.options.bearing)
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
)

_.extend(SitsApp.Views.ShipDetailNavInput.prototype, Observer)