class @Question
  @_getRandomDocFromCollection: (doc, collection) ->
    unless doc?
      doc = {}
    numberOfMatchingDocs = collection.find(doc).count()
    skip = Math.floor(Math.random() * numberOfMatchingDocs)
    collection.findOne doc, skip: skip

  @_getRandomFilm: (doc) ->
    Question._getRandomDocFromCollection(doc, Events)

  @_getRandomDirector: (doc) ->
    Question._getRandomDocFromCollection(doc, Directors)

  @_getThreeRandomFilmsWithDifferentYears: ->
    excludeIds = []
    previousYears = []
    films = []
    for i in [0..2]
      film = Question._getRandomFilm
        _id:
          $nin: excludeIds
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

  @_getRandomFilms: (doc, amount) ->
    excludeIds = []
    films = []
    for i in [0...amount]
      queryDoc = _.clone doc
      queryDoc._id = $nin: excludeIds
      film = Question._getRandomFilm queryDoc
      films.push film
      excludeIds.push film._id
    films

  @getRandomQuestion: ->
    questionFunc = Random.choice [
      Question.getWhatFilmDidThisDirectorDirect,
      Question.getYearOfReleaseQuestion
    ]
    questionFunc()

  @getYearOfReleaseQuestion: ->
    films = Question._getThreeRandomFilmsWithDifferentYears()
    answerFilmIndex = Math.floor(Math.random() * films.length)
    answerFilm = films[answerFilmIndex]
    _id: Random.id()
    question: "was released in which year?"
    keyWord: answerFilm.title
    choices: _.map films, (film) -> film.yearReleased
    answerIndex: answerFilmIndex

  @getWhatFilmDidThisDirectorDirect: ->
    director = Question._getRandomDirector()
    directorsFilm = Question._getRandomFilm
      directorIds:
        $in: [director._id]
    nonDirectorsFilms = Question._getRandomFilms
      directorIds:
        $nin: [director._id]
    ,
      2
    answerIndex = Math.floor(Math.random() * nonDirectorsFilms.length + 1)
    nonDirectorsFilms.splice(answerIndex, 0, directorsFilm)
    _id: Random.id()
    question: "directed which one of these films?"
    keyWord: director.name
    choices: _.map nonDirectorsFilms, (film) -> film.title
    answerIndex: answerIndex

