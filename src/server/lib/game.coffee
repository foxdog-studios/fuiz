CHARACTERS = Meteor.settings.characters or 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
GAMES = {}

class @Game
  constructor: (@_doc) ->
    @_callback = => @_update()
    @_interval = 1000 / 10
    @_questionTime = 5000

  _update: ->
    if (timeLeft = Date.now() - @_doc.startedAt) > @_questionTime
      @_checkAnswers()
      return @_stopUpdate()
    @_doc.timeLeft = timeLeft
    @save()

  _checkAnswers: ->
    correctAnswers = Answers.find
      answer: 'a'
    correctAnswers.forEach (correctAnswer) ->
      console.log correctAnswer
      Players.update
        playerId: correctAnswer.playerName
      ,
        $inc:
          points: 1

  _stopUpdate: ->
    Meteor.clearInterval GAMES[@_doc.name]
    @_doc.timeLeft = null
    @save()
    delete GAMES[@_doc.name]

  getName: ->
    @_doc.name

  nextQuestion: ->
    @_doc.startedAt = Date.now()
    @_doc.question = 'What is the more expensive movie?'
    GAMES[@_doc.name] = Meteor.setInterval @_callback, @_interval
    return

  save: ->
    Games.upsert name: @_doc.name, @_doc
    return

  @get: (name) ->
    unless (doc = Games.findOne name: name)?
      doc =
        createdAt: Date.now()
        questions: []
        name: name
    new Game doc

  @reset: (name) ->
    Games.remove name: name
    Players.remove gameName: name
    Answers.remove gameName: name
    return

