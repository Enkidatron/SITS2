SitsApp.Routers.Ships = Backbone.Router.extend(
	routes: 
		"(/)(#)": "index"
		"ships/detail/:id(/)": "detail"
	index: ->
		console.log('router.index')
		view = new SitsApp.Views.ShipsIndex { collection: SitsApp.ships, className: "col-md-12" }
		$('#shipListRow').html(view.render().$el)
	detail: (id) ->
		view = new SitsApp.Views.ShipsIndex { collection: SitsApp.ships, className: "col-md-12" }
		$('#shipListRow').html(view.render().$el)
		SitsApp.currentShip = new SitsApp.Models.ShipDetail({id: id})
		SitsApp.currentShip.fetch()
		navView = new SitsApp.Views.ShipDetailNavigation({model: SitsApp.currentShip})
		$('#navigationRow').html(navView.render().$el)
	)