Meteor.publish 'master', (gameName) ->
  check gameName, String
  gameCursor = Games.find
    name: gameName
  ,
    fields:
      track: 0
  playerCursor = Players.find
    gameName: gameName
  ,
    fields:
      character: 1
      playerId: 1
  answersCursor = Answers.find
    gameName: gameName
  [ gameCursor, playerCursor, answersCursor ]

Meteor.publish 'playerName', ->
  playerCursor = Players.find
    name: @connection.id
  ,
    fields:
      name: 1
      character: 1
      score: 1

Meteor.publish 'scoreboard', (gameName) ->
  check gameName, String
  Games.find
    name: gameName
  ,
    fields:
      scoreboard: 1

Meteor.publish 'player', (gameName)->
  check gameName, String
  gameCursor = Games.find
    name: gameName
  ,
    fields:
      startedAt: 1
  playerCursor = Players.find
    playerId: @connection.id
  ,
    fields:
      character: 1
      gameName: 1
      playerId: 1
  [ gameCursor, playerCursor ]

