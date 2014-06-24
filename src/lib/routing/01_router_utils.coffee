class @RouterUtils
  @makePath: (pathSuffix = null) ->
    parts = []
    if Settings.rooms.enabled
      parts.push ':roomName'
    if pathSuffix?
      parts.push pathSuffix
    '/' + parts.join '/'

