class Jumbotron
	constructor: (@domElement, @options) ->
		@$ = $ @domElement
		@slideshowInterval = null

		if @$.find("#{@options.slideSelector}.#{@options.activeClassname}").length is 0
			@$.find("#{@options.slideSelector}:first").addClass(@options.activeClassname)

		@startSlideshow() if @options.slideshow
		@initializeSwitcher() if @options.switcher

	initializeSwitcher: ->
		$switcher = @$.find @options.switcherSelector
		$switcher.find("[rel=slide]").each (i, el) =>
			$(el).bind @options.switcherEvent, =>
				@showSlide i

	switchSlides: ($previousSlide, $nextSlide) ->
		console.log "switchSlides"
		console.log $previousSlide
		console.log $nextSlide

		# ToDo: parametrize it
		$previousSlide.removeClass @options.activeClassname
		$nextSlide.addClass @options.activeClassname

	showSlide: (slide) ->
		$previousSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = null
		switch typeof slide
			when 'number'
				$nextSlide = @$.find "#{@options.slideSelector}:eq(#{slide})"
			when 'object'
				$nextSlide = slide
			# ToDo: accept slide by index, domElement, $(domElement)
		
		return if $nextSlide is $previousSlide

		@switchSlides $previousSlide, $nextSlide

	nextSlide: ->
		$activeSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = $activeSlide.next @options.slideSelector
		$nextSlide = @$.find "#{@options.slideSelector}:first" if $nextSlide.length is 0
		@showSlide $nextSlide

	startSlideshow: ->
		@stopSlideshow()
		@slideshowInterval = setInterval @nextSlide.bind(@), @options.slideshowInterval
	stopSlideshow: ->
		clearInterval @slideshowInterval if @slideshowInterval

$.fn.jumbotron = (options) ->
	defaults =
		switcher: off
		slideshow: on
		slideshowInterval: 5000
		slideSelector: '.slides > div'
		activeClassname: 'active'
		switcherSelector: '.switcher'
		switcherEvent: 'mouseover'
	options = $.extend {}, defaults, options

	$.each @, ->
		$(@).data 'jumbotron', new Jumbotron @, options

	return @
