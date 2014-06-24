Template.player.helpers
  player: ->
    Players.findOne()

Template.player.events
  'click [name="a"]': (event) ->
    Player.chooseAnswer @roomName, 'a'

  'click [name="b"]': (event) ->
    Player.chooseAnswer @roomName, 'b'

  'click [name="c"]': (event) ->
    Player.chooseAnswer @roomName, 'c'

