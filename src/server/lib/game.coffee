CHARACTERS = Meteor.settings.characters or 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
GAMES = {}

class @Game
  constructor: (@_doc) ->

  getName: ->
    @_doc.name

  isStarted: ->
    @_doc.startedAt?

  start: ->
    if @isStarted()
      throw new Meteor.Error 422, "This game has already started."
    @_doc.startedAt = Date.now()
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

