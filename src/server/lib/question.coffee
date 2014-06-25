class @Question
  @_getRandomFilm: (doc, excludeIds) ->
    doc._id =
      $nin: excludeIds
    numberOfMatchingFilms = Films.find(doc).count()
    skip = Math.floor(Math.random() * numberOfMatchingFilms)
    Films.findOne doc, skip: skip

  @_getThreeRandomFilmsWithDifferentYears: ->
    excludeIds = []
    previousYears = []
    films = []
    for i in [0..2]
      film = @_getRandomFilm
        year:
          $exists: true
          $nin: previousYears
      ,
        excludeIds
      films.push film
      excludeIds.push film._id
      previousYears.push film.year
    films

  @getYearOfReleaseQuestion: ->
    films = @_getThreeRandomFilmsWithDifferentYears()
    answerFilmIndex = Math.floor(Math.random() * films.length)
    answerFilm = films[answerFilmIndex]
    question: "When was #{answerFilm.Title} released?"
    choices: _.map films, (film) -> film.year
    answerIndex: answerFilmIndex

