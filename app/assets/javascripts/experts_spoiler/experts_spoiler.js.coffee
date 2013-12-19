@init_experts_spoiler = () ->
  button = $('.experts_toggler')
  spoiler = $('.experts_spoiler')
  spoiler.hide()
  button.on 'click', () ->
    spoiler.slideToggle('slow')
    false

  true
