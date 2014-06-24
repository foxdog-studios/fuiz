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
    Games.update
      name: gameName
    ,
      $set:
        question: 'What is the more expensive movie?'

  'chooseAnswer': withPlayerName (playerName, gameName, answer) ->
    game = Games.findOne
      name: gameName
    return unless (question = game?.question)
    currentAnswer = Answers.findOne
      playerName: playerName
      gameName: gameName
      question: question
    return if currentAnswer?
    Answers.insert
      playerName: playerName
      gameName: gameName
      question: question
      answer: answer

  'leave': withPlayerName (playerName) ->
    Player.leave playerName
    return

  'resetGame': (gameName) ->
    Game.reset gameName
    return

  'startGame': (gameName) ->
    game = Game.get(gameName)
    game.start()
    game.save()
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

