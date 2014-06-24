class @Game
  @currentAnswer: ->
    game = Games.findOne()
    game?.currentAnswer

