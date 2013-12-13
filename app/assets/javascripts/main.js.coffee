$ ->
  init_archive_collapser() if $('.archive').length
  init_colorbox() if $('a.colorbox').length
  init_experts_spoiler() if $('#experts_spoiler').length

  true
