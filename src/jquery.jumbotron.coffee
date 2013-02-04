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
		# ToDo: parametrize it ## ? how?? examples?
		$previousSlide.removeClass @options.activeClassname
		$nextSlide.addClass @options.activeClassname

	showSlide: (slide) ->
		$previousSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = null
		switch typeof slide
			when 'string'
				switch slide
					when 'next' then @showSlide(@getActiveSlideIndex() + 1)
					when 'prev' then @showSlide(@getActiveSlideIndex() - 1)
					when 'first' then @showSlide(0)
					when 'last' then @showSlide(@getSlidesCount() - 1)
					else console.error("Unsupported show slide command #{slide}")
				return @
			when 'number'
				$nextSlide = @$.find "#{@options.slideSelector}:eq(#{slide % @getSlidesCount()})"
			when 'object'
				$nextSlide = slide
				# ToDo: accept slide by index, domElement, $(domElement)
			else console.error("Unsupported show slide parametr with type #{typeof slide}")
		if $nextSlide isnt $previousSlide
			@switchSlides $previousSlide, $nextSlide
			@restartSlideshow() if @slideshowInterval
		@ # allows do chain calls

	getActiveSlide: -> @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
	getActiveSlideIndex: -> @getSlides().index(@getActiveSlide())
	getSlidesCount: -> @getSlides().length
	getSlides: -> @$.find("#{@options.slideSelector}")

	next: -> @showSlide('next')
	prev: -> @showSlide('prev')
	last: -> @showSlide('last')
	first: -> @showSlide('first')

	restartSlideshow: ->  @startSlideshow()

	startSlideshow: ->
		@stopSlideshow()
		@slideshowInterval = setInterval @next.bind(@), @options.slideshowInterval
		@ # allows to do chain calls
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
