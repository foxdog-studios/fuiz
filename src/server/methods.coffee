withPlayerName = (func) ->
  (args...) ->
    # If the server calls this (it shouldn't), @connection will be
    # null.
    unless (conn = @connection)?
      throw '@connection must be defined and not null.'
    func.call this, conn.id, args...

queue = new PowerQueue()

Meteor.methods
  'joinRoom': withPlayerName (playerName, gameName) ->
    check playerName, String
    check gameName, String
    joinInQueue @connection, playerName, gameName
    return playerName

  'nextQuestion': (gameName) ->
    game = Game.get(gameName)
    return if game.isInQuestion()
    game.nextQuestion()
    game.save()

  'chooseAnswer': withPlayerName (playerId, gameName, answer) ->
    check playerId, String
    check gameName, String
    check answer, Number
    game = Game.get(gameName)
    return unless game?.isInQuestion()
    return unless (question = game?.getQuestion())
    currentAnswer = Answers.findOne
      playerId: playerId
      gameName: gameName
      questionId: question._id
    return if currentAnswer?
    Answers.insert
      playerId: playerId
      gameName: gameName
      questionId: question._id
      answer: answer

  'leave': withPlayerName (playerName) ->
    Player.leave playerName
    return

  'resetGame': (gameName) ->
    Game.reset gameName
    return

  'startGame': (gameName) ->

    return

joinInQueue = (connection, playerName, gameName) ->
  queue.add (done) ->
    join connection, playerName, gameName
    done()

join = (connection, playerName, gameName) ->
  # Ensure the player leaves when they disconnect.
  connection.onClose -> Player.leave playerName

  # Join the game
  game = Game.get gameName
  player = Player.get playerName
  player.join game
  game.save()
  player.save()

  # Return nothing
  return

