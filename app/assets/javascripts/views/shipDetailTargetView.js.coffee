SitsApp.Views.ShipDetailTargetView = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.model, "destroy", this.leave)
		this.bindTo(this.model, "change", this.render)
	events: 
		"click #delete-target": "deleteTarget"
		"hidden.bs.modal": "setdistance"
	leave: ->
		this.unbindFromAll()
		this.remove()
	render: ->
		this.$el.html(JST['ships/targetPanelTargetlistLineitem']({model: this.model}))
		this.form = new Backbone.Form(
			schema:
				distance: 'Text'
			data:
				distance: this.model.get('distance')
			).render()
		this.$('.modal-body').html(this.form.el)
		return this
	deleteTarget: ->
		this.model.destroy()
	setdistance: ->
		this.model.setdistance(this.form.getValue().distance)
		console.log(this)
)

_.extend(SitsApp.Views.ShipDetailTargetView.prototype, Observer)