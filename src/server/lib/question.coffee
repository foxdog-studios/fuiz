class @Question
  @_getRandomFilm: (doc, excludeIds) ->
    doc._id =
      $nin: excludeIds
    numberOfMatchingFilms = Events.find(doc).count()
    skip = Math.floor(Math.random() * numberOfMatchingFilms)
    Events.findOne doc, skip: skip

  @_getThreeRandomFilmsWithDifferentYears: ->
    excludeIds = []
    previousYears = []
    films = []
    for i in [0..2]
      film = @_getRandomFilm
        yearReleased:
          $exists: true
          $nin: previousYears
        isLive: false
        isPreview: false
        certificate:
          $exists: true
      ,
        excludeIds
      films.push film
      excludeIds.push film._id
      previousYears.push film.yearReleased
    films

  @getYearOfReleaseQuestion: ->
    films = @_getThreeRandomFilmsWithDifferentYears()
    answerFilmIndex = Math.floor(Math.random() * films.length)
    answerFilm = films[answerFilmIndex]
    question: "When was #{answerFilm.Title} released?"
    choices: _.map films, (film) -> film.yearReleased
    answerIndex: answerFilmIndex

