GAMES = {}

class @Game
  constructor: (@_doc) ->
    @_callback = => @_update()
    @_interval = 1000 / 10
    @_questionTime = 5000

  _update: ->
    if (timeSoFar = Date.now() - @_doc.startedAt) > @_questionTime
      @_checkAnswers()
      return @_stopUpdate()
    @_doc.timeLeft = @_questionTime - timeSoFar
    @save()

  _checkAnswers: ->
    correctAnswers = Answers.find
      questionId: @_doc.question._id
      answer: @_doc.question.answer
    @_doc.currentAnswer = @_doc.question.answer
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

  _getAnUnaskedQuestion: ->
    Questions.findOne
      _id:
        $nin: @_doc.questionsAskedIds

  nextQuestion: ->
    @_doc.startedAt = Date.now()
    question = @_getAnUnaskedQuestion()
    return unless question?
    @_doc.questionsAskedIds.push question._id
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
        questionsAskedIds: []
    new Game doc

  @reset: (name) ->
    game = Game.get(name)
    game._stopUpdate()
    Games.remove name: name
    Players.remove gameName: name
    Answers.remove gameName: name
    return

