GAMES = {}

class @Game
  constructor: (@_doc) ->
    @_callback = => @_update()
    @_interval = 1000 / 10
    @_questionTime = 5000

  _update: ->
    if (timeSoFar = Date.now() - @_doc.startedAt) > @_questionTime
      @_checkAnswers()
      @_stopUpdate()
      return
    @_doc.timeLeft = @_questionTime - timeSoFar
    @save()

  _checkAnswers: ->
    correctAnswers = Answers.find
      question: @_doc.question.question
      answer: @_doc.question.answerIndex
    @_doc.currentAnswer = @_doc.question.answerIndex
    correctAnswers.forEach (correctAnswer) =>
      Players.update
        playerId: correctAnswer.playerId
      ,
        $inc:
          score: 1

  _stopUpdate: ->
    Meteor.clearInterval GAMES[@_doc.name]
    @_doc.timeLeft = null
    @save()
    delete GAMES[@_doc.name]

  getName: ->
    @_doc.name

  getQuestion: ->
    @_doc.question

  nextQuestion: ->
    @_doc.startedAt = Date.now()
    question = Question.getYearOfReleaseQuestion()
    return unless question?
    @_doc.question = question
    @_doc.currentAnswer = null
    GAMES[@_doc.name] = Meteor.setInterval @_callback, @_interval
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
    new Game doc

  @reset: (name) ->
    game = Game.get(name)
    game._stopUpdate()
    Games.remove name: name
    Players.remove gameName: name
    Answers.remove gameName: name
    return

