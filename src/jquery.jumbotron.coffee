class Jumbotron
	constructor: (@domElement, @options) ->
		@$ = $ @domElement
		@slideshowInterval = null

		if @$.find("#{@options.slideSelector}.#{@options.activeClassname}").length is 0
			@$.find("#{@options.slideSelector}:first").addClass(@options.activeClassname)

		@startSlideshow() if @options.slideshow

	switchSlides: ($previousSlide, $nextSlide) ->
		console.log "switchSlides"
		console.log $previousSlide
		console.log $nextSlide
		$previousSlide.removeClass @options.activeClassname
		$nextSlide.addClass @options.activeClassname

	showSlide: (slide) ->
		$previousSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = null
		switch typeof slide
			when 'slide'
				$nextSlide = @$.find "#{@options.slideSelector}:index(#{slide})"
			when 'object'
				$nextSlide = slide
			# ToDo: accept slide by index, domElement, $(domElement)
		
		return if $nextSlide is $previousSlide

		@switchSlides $previousSlide, $nextSlide

	nextSlide: ->
		$activeSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = $activeSlide.next()
		$nextSlide = @$.find "#{@options.slideSelector}:first" if $nextSlide.length is 0
		@showSlide $nextSlide

	startSlideshow: ->
		@stopSlideshow()
		@slideshowInterval = setInterval @nextSlide.bind(@), @options.slideshowInterval
	stopSlideshow: ->
		clearInterval @slideshowInterval if @slideshowInterval

$.fn.jumbotron = (options) ->
	defaults =
		slideshow: off
		slideshowInterval: 5000
		slideSelector: '> .slide'
		activeClassname: 'active'
	options = $.extend {}, defaults, options

	$.each @, ->
		$(@).data 'jumbotron', new Jumbotron @, options

	return @
