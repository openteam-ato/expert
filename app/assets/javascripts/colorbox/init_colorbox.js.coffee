@init_colorbox = ->
  $('a.colorbox').colorbox
    close: 'закрыть'
    current: '{current} / {total}'
    imgError: 'Ошибка загрузки изображения'
    maxHeight: '98%'
    maxWidth: '98%'
    next: 'вперёд'
    previous: 'назад'
    returnFocus: false

  true
