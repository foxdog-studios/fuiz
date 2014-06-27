Template.master.rendered = ->
  $(window).keydown (event) =>
    switch event.keyCode
      when KeyCodes.R
        Game.resetGame(@data.roomName)
      when KeyCodes.RIGHT_ARROW
        Game.nextQuestion(@data.roomName)

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

  playerState: ->
    hasCorrectAnswer = Player.hasCorrectAnswer(@playerId)
    if hasCorrectAnswer?
      if hasCorrectAnswer
        return 'correct'
      else
        return 'wrong'
    if Player.hasAnsweredCurrentQuestion(@playerId)
      return 'answered'
    if Game.currentAnswer()
      return 'no-answer'

  correctChoice: ->
    return unless @isCorrectAnswer?
    if @isCorrectAnswer
      'correct'
    else
      'wrong'

  players: ->
    Players.find()

  answer: ->
    ['a', 'b', 'c'][Player.currentAnswer(@playerId)]

  questionNumber: ->
    Game.getQuestionNumber()

  totalNumberOfQuestions: ->
    Meteor.settings.public.game.numberOfQuestions

  isGameOver: ->
    Game.isGameOver()

  timeLeft: ->
    return unless (timeLeft = Game.timeLeft())
    "#{(timeLeft / 1000).toPrecision(2)}s"

  timerPercent: ->
    unless (timeLeft = Game.timeLeft())
      return 0
    (timeLeft / Meteor.settings.public.game.questionTime) * 100

  inQuestion: ->
    Game.inQuestion() and not Game.isGameOver()


Template.master.events
  'click [name="reset"]': ->
    Game.resetGame(@roomName)

  'click [name="next-question"]': ->
    Game.nextQuestion(@roomName)

