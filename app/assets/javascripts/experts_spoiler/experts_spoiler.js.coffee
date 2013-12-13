@init_experts_spoiler = () ->
  button = $('#experts_spoiler')
  spoiler = $('#e_spoiler')
  spoiler.hide()
  button.on 'click', () ->
    spoiler.slideToggle('slow')




