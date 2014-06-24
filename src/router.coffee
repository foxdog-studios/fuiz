Router.map ->
  @route 'player',
    path: RouterUtils.makePath()
    controller: 'PlayerRouteController'

  if Settings.rooms.enabled
    options = if Settings.rooms.random
      where: 'server'
      controller: 'RandomRoomRouteController'
    else
      controller: 'LobbyRouteController'
    @route 'lobby', _.extend options,
      path: '/'

