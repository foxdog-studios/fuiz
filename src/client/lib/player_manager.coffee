class @PlayerManager
  constructor: (@_roomName) ->
    @_player = null
    @_playerId = null

    @_playerDep = new Deps.Dependency
    @_playerIdDep = new Deps.Dependency


  # = Player ID ==============================================================

  _getPlayerId: ->
    @_playerIdDep.depend()
    @_playerId

  _setPlayerId: (playerId) ->
    if playerId != @_playerId
      @_playerId = playerId
      @_playerIdDep.changed()


  # = Player =================================================================

  getPlayer: ->
    @_playerDep.depend()
    @_player

  _setPlayer: (player) =>
    @_player = player
    @_playerDep.changed()
    unless player?
      @_joinRoom()


  # = Rooms ==================================================================

  _joinRoom: ->
    Meteor.call 'joinRoom', @_roomName, (error, playerId) =>
      if error?
        console.error error
      else if @_running
        @_setPlayerId playerId

  _leaveRoom: ->
    Meteor.call 'leaveRoom', (error) ->
      console.error error if error?


  # = Player subscription ====================================================

  _subscribe: =>
    @_unsubscribe()
    if (playerId = @_getPlayerId())?
      @_subscription = Meteor.subscribe 'player', @_roomName

  _unsubscribe: ->
    if @_subscription?
      @_subscription.stop()
      delete @_subscription


  # = Player observation =====================================================

  _startObserving: =>
    @_stopObserving()
    if (playerId = @_getPlayerId())?
      cursor = Players.find
        playerId: playerId
        gameName: @_roomName
      @_observer = cursor.observe
        added: @_setPlayer
        changed: @_setPlayer
        removed: (oldPlayer) =>
          @_setPlayer null

  _stopObserving: ->
    if @_observer?
      @_observer.stop()
      delete @_observer


  # = Controls ===============================================================

  ready: ->
    @getPlayer()?

  start: ->
    return if @_running
    @_subscribeComp = Deps.autorun @_subscribe
    @_observerComp = Deps.autorun @_startObserving
    @_joinRoom()
    @_running = true

  stop: ->
    return unless @_running
    @_subscribeComp.stop()
    @_observerComp.stop()
    delete @_subscribeComp
    delete @_observerComp
    @_stopObservingPlayer()
    @_unsubscribe()
    @_leaveRoom()
    @_running = false

