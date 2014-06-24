class @Player
  constructor: (@_doc) ->

  _hasJoined: ->
    @_doc.gameName?

  join: (game) ->
    @_doc.gameName = game.getName()
    @_doc.joinedAt = Date.now()
    return

  leave: ->
    if @_hasJoined
      game = Game.get @_doc.gameName
      game.save()
    return

  save: ->
    doc = _.omit @_doc, '_id'
    Players.upsert playerId: doc.playerId,
      $set: doc
    return

  @get: (playerId) ->
    doc = Players.findOne playerId: playerId
    unless doc?
      doc = playerId: playerId
    new Player doc

  @leave: (playerId) ->
    check playerId, String
    player = Player.get playerId
    player.leave()
    Players.remove playerId: playerId
    return

