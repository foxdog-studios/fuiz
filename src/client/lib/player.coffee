class @Player
  @chooseAnswer: (roomName, answer) ->
    Meteor.call 'chooseAnswer', roomName, answer, (error, result) ->
      if error?
        console.error error

  @_getPlayerAnswer: (playerId) ->
    game = Games.findOne()
    return unless (question = game?.question)
    Answers.findOne
      questionId: question._id
      playerId: playerId

  @currentAnswer: (playerId) ->
    Player._getPlayerAnswer(playerId)?.publicAnswer

  @hasAnsweredCurrentQuestion: (playerId) ->
    Player._getPlayerAnswer(playerId)?

  @hasCorrectAnswer: (playerId) ->
    playerAnswer = Player.currentAnswer(playerId)
    return unless playerAnswer?
    currentAnswer = Game.currentAnswer()
    return unless currentAnswer?
    playerAnswer == currentAnswer

