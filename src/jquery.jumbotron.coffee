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
		$previousSlide.removeClass @options.activeClassname
		if @options.switcher
			i = @getSlides().index($nextSlide)
			@$.find(@options.switcherSelector).removeClass @options.activeClassname
			@$.find(@options.switcherSelector).eq(i).addClass @options.activeClassname
		$nextSlide.addClass @options.activeClassname

	showSlide: (slide) ->
		$previousSlide = @$.find "#{@options.slideSelector}.#{@options.activeClassname}"
		$nextSlide = null
		switch typeof slide
			when 'string'
				slide = $.trim(slide)
				if slide[0] in ['-', '+'] and !isNaN(offset = parseInt(slide))
					return @showSlide(@getActiveSlideIndex() + offset)
				switch slide
					when 'random' then @showSlide(Math.floor(Math.random() * 1000000))
					when 'next' then @showSlide(@getActiveSlideIndex() + 1)
					when 'prev' then @showSlide(@getActiveSlideIndex() - 1)
					when 'first' then @showSlide(0)
					when 'last' then @showSlide(@getSlidesCount() - 1)
					else console.error("Unsupported show slide command #{slide}")
				return @
			when 'number'
				$nextSlide = @$.find "#{@options.slideSelector}:eq(#{slide % @getSlidesCount()})"
			when 'object'
				if (newIndex = @getSlides().index(slide)) is -1
					console.error "Invalid object provided as switchSlide Element"
				else
					@showSlide(newIndex)
				return @
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
		@slideshowInterval = null
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
