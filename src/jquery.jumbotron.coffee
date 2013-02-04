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
		$switcher.each (i, el) =>
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
			when 'string' then switch slide
				when 'next' then console.warn 'not implemented'
				when 'prev' then console.warn 'not implemented'
				when 'first' then console.warn 'not implemented'
				when 'last' then console.warn 'not implemented'
				else console.error 'Unsupported show slide command ' + slide

			when 'number'
				$nextSlide = @$.find "#{@options.slideSelector}:eq(#{slide})" #ToDo: check range
			when 'object'
				$nextSlide = slide
			# ToDo: accept slide by index, domElement, $(domElement)
		
		if $nextSlide isnt $previousSlide
			@switchSlides $previousSlide, $nextSlide
			@restartSlideshow() if @slideshowInterval
		@ # allows do chain calls

	nextSlide: -> # ToDo: move to showSlide
		$activeSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = $activeSlide.next @options.slideSelector
		$nextSlide = @$.find "#{@options.slideSelector}:first" if $nextSlide.length is 0
		@showSlide $nextSlide

	startSlideshow: ->
		@stopSlideshow()
		@slideshowInterval = setInterval @nextSlide.bind(@), @options.slideshowInterval
		@ # allows to do chain calls
	restartSlideshow: ->
		@startSlideshow()
		@
	stopSlideshow: ->
		clearInterval @slideshowInterval if @slideshowInterval
		@ # allows to do chain calls

$.fn.jumbotron = (options) ->
	defaults =
		switcher: off
		slideshow: on
		slideshowInterval: 5000
		slideSelector: '.slides > div'
		activeClassname: 'active'
		switcherSelector: '.switcher li'
		switcherEvent: 'mouseover'
	options = $.extend {}, defaults, options

	$.each @, ->
		$(@).data 'jumbotron', new Jumbotron @, options

	return @
