# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.SitsApp = 
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	initialize: (ships) ->
		this.ships = new SitsApp.Collections.Ships(ships)
		this.router = new SitsApp.Routers.Ships()
		unless Backbone.history.started
			Backbone.history.start()
			Backbone.history.started = true