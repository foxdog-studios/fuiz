@Settings = Meteor.settings?.public ? {}


# 1) Public settings
_.defaults Settings,
  rooms: {}


# 1.1) Room settings
_.defaults Settings.rooms,
  enabled: false
  default: 'fuiz'
  random: false

