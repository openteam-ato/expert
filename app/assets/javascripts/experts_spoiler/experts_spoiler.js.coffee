@init_experts_spoiler = () ->
  button = $('.blue_pages .experts_toggler')
  spoiler = $('.blue_pages .experts_spoiler')
  spoiler.hide()
  button.on 'click', () ->
    spoiler.slideToggle('slow')




