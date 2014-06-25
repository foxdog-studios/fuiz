class @Game
  @currentAnswer: ->
    game = Games.findOne()
    game?.currentAnswer

  @getCurrentChoices: ->
    game = Games.findOne()
    return [] unless (question = game?.question)
    letters = ['a', 'b', 'c']
    isCurrentAnswer = (answerIndex) ->
      answer = Game.currentAnswer()
      unless answer?
        return
      else if answerIndex == answer
        '✓'
      else
        '✗'
    for choice, index in question.choices
      letter: letters[index]
      choice: choice
      isCorrectAnswer: isCurrentAnswer(index)

