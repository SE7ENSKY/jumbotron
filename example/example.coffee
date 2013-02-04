$ ->
	$(".jumbotron").jumbotron
		slideshow: off
		slideshowInterval: 2500
		switcher: on
		switcherSelector: '.switcher li'
	window.api = $(".jumbotron").data('jumbotron')