class @RandomRoomRouteController extends RouteController
  action: ->
    @response.writeHead 307,
      Location: Router.path 'player', roomName: @_makeRandomRoomName()
    @response.end()

  _makeRandomRoomName: ->
    first = third = 'abcdefghijklmnopqrstuvwxyz'
    second = 'aeiou'
    _.map([first, second, third], (letters) -> Random.choice letters).join ''

