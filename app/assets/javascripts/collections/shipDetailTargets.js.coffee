SitsApp.Collections.ShipDetailTargets = Backbone.Collection.extend(
	initialize: ->
		this._meta = {}
		this.meta('id',1)
	model: SitsApp.Models.ShipDetailTarget
	addTarget: (target) ->
		target.set({'id': this.meta('id')})
		this.meta('id', this.meta('id') + 1)
		this.add(target)
	setParent: (parent) ->
		this.meta('parent',parent)
	meta: (prop, value) ->
		if value?
			this._meta[prop] = value
		else
			return this._meta[prop]
)