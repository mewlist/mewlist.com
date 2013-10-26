# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Animation
  ready: () ->
      @setup()

  setup: () ->
    $(window).scroll () =>
      @scrolling()
    @scrolling()

  scrolling: () ->
    animation = @
    @window_height ||= $(window).height()
    bottom = $(window).scrollTop() + @window_height
    $('.animate.container').each () ->
      elem = @
      pos = $(elem).offset().top
      if bottom > pos
        $(elem).removeClass('animate')
        $(elem).addClass('animated')
        animation.animate $('.animate.first', elem), () =>
          animation.animate $('.animate.second', elem), () =>
            animation.animate $('.animate.third', elem), () =>
              animation.animate $('.animate.termination', elem), () =>

  animate: (selector, callback) ->
    callback() if $(selector).length == 0
    $(selector).each () ->
      attrs = {}
      easing = "linear"
      klasses = $(@).attr('class').split(/\s+/)
      for i, klass of klasses
        switch klass
          when 'fadein'
            attrs['opacity'] = 1
          when 'slidein'
            attrs['margin-left'] = 0
          when 'easeout'
            easing = 'easeOutCubic'
      $(@).animate(attrs, 700, easing, callback)

class Router
  @instance: () ->
    @router ||= new Router()
    @router

  dispatch: () ->
    (new Animation).ready()
    switch window.location.pathname
      when '/'
        console.log('welcome')
      else
        switch
          when window.location.pathname.match(/^\/blog/)
            console.log('blog')


onload = () ->
  setTimeout () ->
    Router.instance().dispatch()
  , 500
  setTimeout () ->
    if typeof FB != 'undefined'
      FB.XFBML.parse document.getElementById('body'), () ->
        console.log 'hoge'
    else
      initFacebook(document, 'script', 'facebook-jssdk')
  , 1900

$(document).on "page:load", () ->
  onload()

$(document).on "page:before-change", () ->
  $('.animated').stop()
  $('.animated').stop()
  $('.animated').stop()

$(document).ready () ->
  onload()
