class @Game
  @currentAnswer: ->
    game = Games.findOne()
    game?.currentAnswer

  @isGameOver: ->
    game = Games.findOne()
    game?.gameOver

  @getQuestionNumber: ->
    game = Games.findOne()
    numberOfQuestionsAsked = game?.numberOfQuestionsAsked
    if numberOfQuestionsAsked > 0
      numberOfQuestionsAsked

  @getCurrentChoices: ->
    game = Games.findOne()
    return [] unless (question = game?.question)
    return [] unless game.timeLeft? or game.currentAnswer?
    letters = ['a', 'b', 'c']
    isCurrentAnswer = (answerIndex) ->
      currentAnswer = Game.currentAnswer()
      return unless currentAnswer?
      answerIndex == currentAnswer
    for choice, index in question.choices
      letter: letters[index]
      choice: choice
      isCorrectAnswer: isCurrentAnswer(index)

  @inQuestion: ->
    game = Games.findOne()
    return unless game?
    return unless game.question?
    not game.currentAnswer?

  @resetGame: (roomName) ->
    Meteor.call 'resetGame', roomName, (error, result) ->
      if error?
        console.error error

  @nextQuestion: (roomName) ->
    Meteor.call 'nextQuestion', roomName, (error, result) ->
      if error?
        console.error error

