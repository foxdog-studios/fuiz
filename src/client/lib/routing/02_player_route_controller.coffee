class @PlayerRouteController extends RoomRouteController
  constructor: ->
    super
    @_playerManager = new PlayerManager @getRoomName()
    @_playerManager.start()

  waitOn: ->
    @_playerManager

  data: ->
    _.extend super(),
      player: @_playerManager.getPlayer()

  onStop: ->
    @_playerManager.stop()
    delete @_playerManager

