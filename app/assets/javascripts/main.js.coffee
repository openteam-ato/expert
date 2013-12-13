$ ->
  init_archive_collapser() if $('.archive').length
  init_colorbox() if $('a.colorbox').length
  init_experts_spoiler() if $('.blue_pages .experts_toggler').length

  true
