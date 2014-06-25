Meteor.startup ->
  if Meteor.settings.resetOnStart
    Games.remove {}
    Players.remove {}
    Answers.remove {}

