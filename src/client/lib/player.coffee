class @Player
  @chooseAnswer: (roomName, answer) ->
    Meteor.call 'chooseAnswer', roomName, answer, (error, result) ->
      if error?
        console.error error

