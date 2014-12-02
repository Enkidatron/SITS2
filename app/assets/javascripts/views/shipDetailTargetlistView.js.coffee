SitsApp.Views.ShipDetailTargetlistView = Backbone.View.extend(
	initialize: ->
		# This was firing on the models destroy event, causing the table to disappear if we remove a row
		# this.bindTo(this.collection, "destroy", this.leave)
		# unnecessary, because our parent view is subscribed to these events
		# this.bindTo(this.collection, "change add remove reset", this.render)
	leave: ->
		console.log('ShipDetailTargetlistView.leave')
		this.unbindFromAll()
		this.remove()
	events:
		"click .new-target": "newtarget"
	render: ->
		self = this
		this.$el.html(JST['ships/targetPanelTargetlist']())
		this.collection.each( (target) ->
			targetView = new SitsApp.Views.ShipDetailTargetView({model: target})
			self.$('#target-list').append(targetView.render().el)
			)
		return self
	newtarget: ->
		this.collection.addTarget(new SitsApp.Models.ShipDetailTarget(this.collection.meta('parent')))
		return false
)

_.extend(SitsApp.Views.ShipDetailTargetlistView.prototype, Observer)