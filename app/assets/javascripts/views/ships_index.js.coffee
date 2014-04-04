SitsApp.Views.ShipsIndex = Backbone.View.extend(
	initialize: ->
		this.bindTo(this.collection, "change", this.render)
	leave: ->
		this.unbindFromAll()
		this.remove()
	render: ->
		self = this
		this.$el.html(JST['ships/index']())
		this.collection.each(->
			shipNavView = new SitsApp.Views.ShipNavView({ model: ship })
			self.$('#shipListToolbar').append(taskView.render().el)
			)
		return this
	)

_.extend(SitsApp.Views.ShipsIndex.prototype, Observer)