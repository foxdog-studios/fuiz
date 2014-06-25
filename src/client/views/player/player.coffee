Template.player.helpers
  player: ->
    Players.findOne()

Template.player.events
  'click [name="a"]': (event) ->
    Player.chooseAnswer @roomName, 0

  'click [name="b"]': (event) ->
    Player.chooseAnswer @roomName, 1

  'click [name="c"]': (event) ->
    Player.chooseAnswer @roomName, 2

