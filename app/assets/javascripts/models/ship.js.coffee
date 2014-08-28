SitsApp.Models.Ship = Backbone.Model.extend(
	urlRoot: '/ships'
	schema: 
		name: 
			type: 'Text'
			validators: ['required']
		ship_class: 
			title: 'Weight Class'
			type: 'Select'
			options: ['DD','CL','CA','BC','BS','DN','SD']
		pivot: 'Number'
		roll: 'Number'
		notes: 'TextArea'
	saveship: ->
		this.save()
		SitsApp.ships.addShip(this)
	)