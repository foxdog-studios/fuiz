Template.master.helpers
  currentQuestion: ->
    game = Games.findOne()
    game?.question

  currentAnswers: ->
    game = Games.findOne()
    return unless (question = game?.question)
    Answers.find
      question: question

Template.master.events
  'click [name="reset"]': ->
    Meteor.call 'resetGame', @roomName, (error, result) ->
      if error?
        console.error error

  'click [name="next-question"]': ->
    Meteor.call 'nextQuestion', @roomName, (error, result) ->
      if error?
        console.error error

