class @Question
  @_getRandomDocFromCollection: (doc, collection) ->
    unless doc?
      doc = {}
    numberOfMatchingDocs = collection.find(doc).count()
    skip = Math.floor(Math.random() * numberOfMatchingDocs)
    collection.findOne doc, skip: skip

  @_ensureFilmHasTMDBDataIfPossible: (film) ->
    return film unless film.theMovieDbId?
    return film if film.theMovieDbData?
    apiKey = Meteor.settings.theMovieDbApiKey
    movieId = film.theMovieDbId
    try
      theMovieDbData = HTTP.get(
        "http://api.themoviedb.org/3/movie/#{movieId}?api_key=#{apiKey}"
      )
      Events.update
        _id: film._id
      ,
        $set:
          theMovieDbData: theMovieDbData.data
      film.theMovieDbData = theMovieDbData.data
      return film
    catch e
      console.error("Error fetching the movie db data", e)
      return film

  @_getRandomFilm: (doc) ->
    film = Question._getRandomDocFromCollection(doc, Events)
    film = Question._ensureFilmHasTMDBDataIfPossible(film)
    film

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

  @_getRandomItems: (doc, amount, randomItemGetter) ->
    excludeIds = []
    items = []
    for i in [0...amount]
      queryDoc = _.clone doc
      unless queryDoc._id?
        queryDoc._id = {}
      unless queryDoc._id.$nin?
        queryDoc._id.$nin = excludeIds
      else
        queryDoc._id.$nin = queryDoc._id.$nin.concat(excludeIds)
      item = randomItemGetter queryDoc
      items.push item
      excludeIds.push item._id
    items

  @_getRandomFilms: (doc, amount) ->
    Question._getRandomItems(doc, amount, Question._getRandomFilm)

  @_getRandomDirectors: (doc, amount) ->
    Question._getRandomItems(doc, amount, Question._getRandomDirector)

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
    theMovieDbData: answerFilm.theMovieDbData

  @getWhatFilmDidThisDirectorDirect: ->
    director = Question._getRandomDirector()
    directorsFilm = Question._getRandomFilm
      directorIds:
        $in: [director._id]
    otherDirectors = Question._getRandomDirectors
      _id:
        $nin: [director._id]
    ,
      2
    answerIndex = Math.floor(Math.random() * otherDirectors.length + 1)
    otherDirectors.splice(answerIndex, 0, director)
    _id: Random.id()
    question: "was directed by?"
    keyWord: directorsFilm.title
    choices: _.map otherDirectors, (director) -> director.name
    answerIndex: answerIndex
    theMovieDbData: directorsFilm.theMovieDbData

