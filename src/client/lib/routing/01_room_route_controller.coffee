class @RoomRouteController extends RouteController
  data: ->
    roomName: @getRoomName()

  getRoomName: ->
    @params.roomName ? Settings.rooms.default

