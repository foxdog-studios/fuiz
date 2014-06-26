Template.player.helpers
  player: ->
    Players.findOne()

Template.player.events
  'touchend [name="a"]': (event) ->
    Player.chooseAnswer @roomName, 0

  'touchend [name="b"]': (event) ->
    Player.chooseAnswer @roomName, 1

  'touchend [name="c"]': (event) ->
    Player.chooseAnswer @roomName, 2

