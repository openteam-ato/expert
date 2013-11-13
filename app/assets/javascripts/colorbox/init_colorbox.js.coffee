@init_colorbox = ->
  $('a.colorbox').colorbox
    current: '{current} / {total}'
    previous: 'назад'
    next: 'вперёд'
    close: 'закрыть'
    maxWidth: '98%'
    maxHeight: '98%'
    imgError: 'Ошибка загрузки изображения'

  true
