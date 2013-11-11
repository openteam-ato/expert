@init_colorbox = ->
  $('a.colorbox').colorbox
    current: '{current} / {total}'
    previous: 'назад'
    next: 'вперёд'
    close: 'закрыть'
    maxWidth: '90%'
    maxHeight: '90%'
    imgError: 'Ошибка загрузки изображения'

  true
