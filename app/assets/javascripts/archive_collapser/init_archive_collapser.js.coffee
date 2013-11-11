@init_archive_collapser = ->
  $('.year', '.archive').each ->
    $(this).next('ul').show() if $(this).hasClass('active')

  $('.year', '.archive').click ->
    $this = $(this)

    $this.toggleClass('active').next('ul').stop(true, true).slideToggle 'slow', ->
      $this.removeClass('busy')

    false
