class Jumbotron
	constructor: (@domElement) ->
		console.log "Jumbotron constructor for"
		console.log @domElement
		$(@domElement).html "I am initialized!"

$.fn.jumbotron = (options) ->
	$.each @, ->
		$(@).data 'jumbotron', new Jumbotron @
	return @
