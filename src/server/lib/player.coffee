class @Player
  constructor: (@_doc) ->

  _hasJoined: ->
    @_doc.gameName?

  join: (game) ->
    @_doc.gameName = game.getName()
    @_doc.joinedAt = Date.now()
    return

  save: ->
    doc = _.omit @_doc, '_id'
    Players.upsert playerId: doc.playerId,
      $set: doc
    return

  @get: (playerId) ->
    doc = Players.findOne playerId: playerId
    unless doc?
      doc =
        playerId: playerId
        name: generateName()
        score: 0
    new Player doc

  @leave: (playerId) ->
    check playerId, String
    Players.remove playerId: playerId
    return

