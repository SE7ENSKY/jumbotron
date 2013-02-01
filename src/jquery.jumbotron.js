// Generated by CoffeeScript 1.4.0
(function() {
  var Jumbotron;

  Jumbotron = (function() {

    function Jumbotron(domElement, options) {
      this.domElement = domElement;
      this.options = options;
      this.$ = $(this.domElement);
      this.slideshowInterval = null;
      if (this.$.find("" + this.options.slideSelector + "." + this.options.activeClassname).length === 0) {
        this.$.find("" + this.options.slideSelector + ":first").addClass(this.options.activeClassname);
      }
      if (this.options.slideshow) {
        this.startSlideshow();
      }
      if (this.options.switcher) {
        this.initializeSwitcher();
      }
    }

    Jumbotron.prototype.initializeSwitcher = function() {
      var $switcher,
        _this = this;
      $switcher = this.$.find(this.options.switcherSelector);
      return $switcher.find("[rel=slide]").each(function(i, el) {
        return $(el).bind(_this.options.switcherEvent, function() {
          return _this.showSlide(i);
        });
      });
    };

    Jumbotron.prototype.switchSlides = function($previousSlide, $nextSlide) {
      console.log("switchSlides");
      console.log($previousSlide);
      console.log($nextSlide);
      $previousSlide.removeClass(this.options.activeClassname);
      return $nextSlide.addClass(this.options.activeClassname);
    };

    Jumbotron.prototype.showSlide = function(slide) {
      var $nextSlide, $previousSlide;
      $previousSlide = this.$.find("" + this.options.slideSelector + "." + this.options.activeClassname);
      $nextSlide = null;
      switch (typeof slide) {
        case 'number':
          $nextSlide = this.$.find("" + this.options.slideSelector + ":eq(" + slide + ")");
          break;
        case 'object':
          $nextSlide = slide;
      }
      if ($nextSlide === $previousSlide) {
        return;
      }
      return this.switchSlides($previousSlide, $nextSlide);
    };

    Jumbotron.prototype.nextSlide = function() {
      var $activeSlide, $nextSlide;
      $activeSlide = this.$.find("" + this.options.slideSelector + "." + this.options.activeClassname);
      $nextSlide = $activeSlide.next(this.options.slideSelector);
      if ($nextSlide.length === 0) {
        $nextSlide = this.$.find("" + this.options.slideSelector + ":first");
      }
      return this.showSlide($nextSlide);
    };

    Jumbotron.prototype.startSlideshow = function() {
      this.stopSlideshow();
      return this.slideshowInterval = setInterval(this.nextSlide.bind(this), this.options.slideshowInterval);
    };

    Jumbotron.prototype.stopSlideshow = function() {
      if (this.slideshowInterval) {
        return clearInterval(this.slideshowInterval);
      }
    };

    return Jumbotron;

  })();

  $.fn.jumbotron = function(options) {
    var defaults;
    defaults = {
      switcher: false,
      slideshow: true,
      slideshowInterval: 5000,
      slideSelector: '.slides > div',
      activeClassname: 'active',
      switcherSelector: '.switcher',
      switcherEvent: 'mouseover'
    };
    options = $.extend({}, defaults, options);
    $.each(this, function() {
      return $(this).data('jumbotron', new Jumbotron(this, options));
    });
    return this;
  };

}).call(this);
