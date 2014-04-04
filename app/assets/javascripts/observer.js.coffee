window.Observer = 
	bindTo: (source, event, callback) ->
		source.on(event, callback, this)
		this.bindings ?= []
		this.bindings.push { source: source, event: event, callback: callback }
	unbindFromAll: ->
		_.each(this.bindings, ((binding) -> binding.source.off(binding.event, binding.callback)))
		this.bindings = []