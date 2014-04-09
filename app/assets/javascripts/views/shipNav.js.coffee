SitsApp.Views.ShipNavView = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "change", this.render)
		this.bindTo(this.model, "destroy", this.leave)
	leave: ->
		this.unbindFromAll()
		this.remove()
	events:
		"hidden.bs.modal": "saveship"
		"click .delete": "deleteship"
	render: ->
		this.$el.html(JST['ships/shipNav']({ model: this.model }))
		this.form = new Backbone.Form(
			model: this.model
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
	saveship: ->
		this.form.commit()
		this.model.saveship()
	deleteship: ->
		this.model.destroy()
	)
	

_.extend(SitsApp.Views.ShipNavView.prototype, Observer)