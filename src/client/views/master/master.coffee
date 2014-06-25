Template.master.helpers
  currentQuestion: ->
    game = Games.findOne()
    game?.question

  choices: ->
    Game.getCurrentChoices()

  players: ->
    Players.find()

  answer: (playerId) ->
   ['a', 'b', 'c'][Player.currentAnswer(playerId)]

  playerIsCorrect: (playerId) ->
    playerAnswer = Player.currentAnswer(playerId)
    return unless playerAnswer?
    currentAnswer = Game.currentAnswer()
    return unless currentAnswer?
    if playerAnswer == currentAnswer
      '✓'
    else
      '✗'

  timeLeft: ->
    game = Games.findOne()
    game?.timeLeft

Template.master.events
  'click [name="reset"]': ->
    Meteor.call 'resetGame', @roomName, (error, result) ->
      if error?
        console.error error

  'click [name="next-question"]': ->
    Meteor.call 'nextQuestion', @roomName, (error, result) ->
      if error?
        console.error error

