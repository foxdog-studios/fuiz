Meteor.startup ->
  if Meteor.settings.resetOnStart
    Games.remove {}
    Players.remove {}
    Answers.remove {}
  Questions.remove {}
  if Questions.find().count() == 0
    questions = [
      question: 'What was the budget for Ace Ventura: Pet Detective?'
      choices:
        a: '$15 million'
        b: '$10 million'
        c: '$18 milllion'
      answer: 'a'
    ,
      question: 'How much did Ace Ventura: Pet Detective Gross?'
      choices:
        a: '$33 million'
        b: '$77 million'
        c: '$102 milllion'
      answer: 'c'
    ]
    for question in questions
      Questions.insert question

