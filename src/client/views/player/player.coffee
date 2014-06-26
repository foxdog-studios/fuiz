Template.player.helpers
  player: ->
    Players.findOne()

  selected: (index) ->
    return unless (player = Players.findOne())
    if player.currentAnswer == index
      return 'selected'


Template.player.events
  'touchend [name="a"], click [name="a"]': (event) ->
    Player.chooseAnswer @roomName, 0

  'touchend [name="b"], click [name="b"]': (event) ->
    Player.chooseAnswer @roomName, 1

  'touchend [name="c"], click [name="c"]': (event) ->
    Player.chooseAnswer @roomName, 2

