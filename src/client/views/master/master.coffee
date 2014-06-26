Template.master.rendered = ->
  $(window).keydown (event) =>
    switch event.keyCode
      when KeyCodes.R
        Meteor.call 'resetGame', @data.roomName, (error, result) ->
          if error?
            console.error error

  @_lastPosterPath = null
  Deps.autorun =>
    game = Games.findOne()
    return unless (question = game?.question)
    imagePath = game?.question?.theMovieDbData?.backdrop_path
    unless imagePath?
      imagePath = game?.question?.theMovieDbData?.poster_path
    unless imagePath?
      return unless @_lastPosterPath != null
      @_lastPosterPath = null
      $('#darken').fadeTo(400, 1, ->
        $('#image').css('background-image', '')
      ).fadeTo(400, 0.5)
      return
    if imagePath != @_lastPosterPath
      @_lastPosterPath = imagePath
    else
      return
    image = new Image
    image.onload = ->
      $('#darken').fadeTo(100, 1, ->
        $('#image').css(
          'background-image',
          "url(#{image.src})"
        )
      ).fadeTo(200, 0.5)
    image.src = "http://image.tmdb.org/t/p/w1000/#{@_lastPosterPath}"

Template.master.helpers
  currentQuestion: ->
    game = Games.findOne()
    game?.question

  choices: ->
    Game.getCurrentChoices()

  hasAnsweredCurrentQuestion:  ->
    if Player.hasAnsweredCurrentQuestion(@playerId)
      '-'

  correctClass: ->
    if @isCorrectAnswer
      'visible'
    else
      'hidden'

  players: ->
    Players.find()

  answer: ->
    ['a', 'b', 'c'][Player.currentAnswer(@playerId)]

  questionNumber: ->
    Game.getQuestionNumber()

  isGameOver: ->
    Game.isGameOver()

  playerIsCorrect: ->
    hasCorrectAnswer = Player.hasCorrectAnswer(@playerId)
    unless hasCorrectAnswer?
      return
    else if hasCorrectAnswer
      '✓'
    else
      '✗'

  playerHasAnswerClass: ->
    if Player.hasCorrectAnswer(@playerId)?
      'visible'
    else
      'hidden'

  timeLeft: ->
    game = Games.findOne()
    return unless (timeLeft = game?.timeLeft)
    "#{(timeLeft / 1000).toPrecision(2)}s"

  inQuestion: ->
    Game.inQuestion() and not Game.isGameOver()


Template.master.events
  'click [name="reset"]': ->
    Meteor.call 'resetGame', @roomName, (error, result) ->
      if error?
        console.error error

  'click [name="next-question"]': ->
    Meteor.call 'nextQuestion', @roomName, (error, result) ->
      if error?
        console.error error

