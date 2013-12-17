@init_jcarousel = ->
  if $('.banners_block ul li').length > 4
    $('.banners_block ul').jcarousel({
      auto: 20,
      wrap: 'circular',
      scroll: 1
    })
