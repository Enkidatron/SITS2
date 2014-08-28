SitsApp.Views.ShipNewView = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "change", this.render)
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, "sync", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	events:
		"hidden.bs.modal": "saveship"
	render: ->
		this.$el.html(JST['ships/shipNew']({ model: this.model }))
		this.form = new Backbone.Form(
			model: this.model
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
	saveship: ->
		this.form.commit()
		this.model.saveship()
	)
	

_.extend(SitsApp.Views.ShipNewView.prototype, Observer)