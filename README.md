jumbotron
=========
early draft
in development

== API ==
* slide(slide) – change slide. 'slide' can be:
** 'previous', 'prev', 'next', 'first', 'last'
** 'random'
** '-2', '+3'
** numeric slide index
** domElement or $(domElement)

== Events ==
* startedSlideshow – when slideshow is started
* stoppedSlideshow – when slideshow is stopped
* slideSwitching(from, to) – when started swithing to a slide
* slideSwitched(from, to) – when finished switching
* ...
