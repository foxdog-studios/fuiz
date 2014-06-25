Meteor.startup ->
  if Meteor.settings.resetOnStart
    Games.remove {}
    Answers.remove {}
  Players.remove {}

