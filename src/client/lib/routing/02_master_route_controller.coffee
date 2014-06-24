class @MasterRouteController extends RoomRouteController
  @pathSuffix: 'master'

  waitOn: ->
    Meteor.subscribe 'master', @getRoomName()

