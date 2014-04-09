SitsApp.Routers.Ships = Backbone.Router.extend(
	routes: 
		"(/)": "index"
	index: ->
		view = new SitsApp.Views.ShipsIndex { collection: SitsApp.ships, className: "col-md-12" }
		$('#shipListRow').html(view.render().$el)
	)