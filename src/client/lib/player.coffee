class @Player
  @chooseAnswer: (roomName, answer) ->
    Meteor.call 'chooseAnswer', roomName, answer, (error, result) ->
      if error?
        console.error error

  @currentAnswer: (playerId) ->
    game = Games.findOne()
    return unless (question = game?.question)
    answer = Answers.findOne
      question: question.question
      playerId: playerId
    answer?.answer

