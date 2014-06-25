GAMES = {}
TIMEOUTS = {}

class @Game
  constructor: (@_doc) ->
    @_callback = => @_update()
    @_interval = 1000 / 10
    @_questionTime = Meteor.settings.game.questionTime
    @_numberOfQuestions = Meteor.settings.game.numberOfQuestions

  _update: ->
    if (timeSoFar = Date.now() - @_doc.startedAt) > @_questionTime
      @_checkAnswers()
      @_stopUpdate()
      return
    @_doc.timeLeft = @_questionTime - timeSoFar
    @save()

  _checkAnswers: ->
    correctAnswers = Answers.find
      questionId: @_doc.question._id
      answer: @_doc.question.answerIndex
    @_doc.currentAnswer = @_doc.question.answerIndex
    correctAnswers.forEach (correctAnswer) =>
      Players.update
        playerId: correctAnswer.playerId
      ,
        $inc:
          score: 1

  stop: ->
    if @_doc.timeLeft?
      @_checkAnswers()
    @_stopUpdate()

  _stopUpdate: ->
    Meteor.clearTimeout TIMEOUTS[@_doc.name]
    Meteor.clearInterval GAMES[@_doc.name]
    @_doc.timeLeft = null
    if @_doc.numberOfQuestionsAsked >= @_numberOfQuestions
      @_doc.gameOver = true
    @save()
    delete GAMES[@_doc.name]
    delete TIMEOUTS[@_doc.name]

  getName: ->
    @_doc.name

  getQuestion: ->
    @_doc.question

  nextQuestion: ->
    return if @_doc.gameOver
    question = Question.getRandomQuestion()
    return unless question?
    @_doc.question = question
    @_doc.currentAnswer = null
    @_doc.numberOfQuestionsAsked += 1
    TIMEOUTS[@_doc.name] = Meteor.setTimeout =>
      @_startTimer()
    , 2000
    return

  _startTimer: ->
    @_doc.startedAt = Date.now()
    GAMES[@_doc.name] = Meteor.setInterval @_callback, @_interval
    @save()
    return

  isInQuestion: ->
    GAMES[@_doc.name]?

  save: ->
    Games.upsert name: @_doc.name, @_doc
    return

  @get: (name) ->
    unless (doc = Games.findOne name: name)?
      doc =
        createdAt: Date.now()
        name: name
        numberOfQuestionsAsked: 0
    new Game doc

  @reset: (name) ->
    game = Game.get(name)
    game._stopUpdate()
    Games.remove name: name
    Players.remove gameName: name
    Answers.remove gameName: name
    return

