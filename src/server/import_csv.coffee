Meteor.startup ->
  if Meteor.settings.resetOnStart
    Events.remove {}
    Directors.remove {}
  return if Events.find().count() > 0

  # Meteor code must be run in fiber so do inserts after async code has run.

  eventsCsv = Assets.getText('events.csv')
  eventDocs = _.map CsvReader.getLinesFromString(eventsCsv), (csvLine) ->
    # Cleaning up
    csvLine.yearReleased = csvLine['Year released']
    delete csvLine['Year released']
    csvLine.isLive = if csvLine['Live?'] > 0 then true else false
    delete csvLine['Live?']
    csvLine.isPreview = if csvLine['Preview?'] > 0 then true else false
    delete csvLine['Preview?']
    csvLine.certificate = csvLine['Certificate']
    delete csvLine['Certificate']
    csvLine._id = csvLine['ID']
    delete csvLine['ID']
    csvLine
  for eventDoc in eventDocs
    Events.insert eventDoc

  directorsCsv = Assets.getText('directors.csv')
  directorDocs = _.map CsvReader.getLinesFromString(directorsCsv), (csvLine) ->
    csvLine.name = csvLine['Name']
    delete csvLine['Name']
    csvLine._id = csvLine['ID']
    delete csvLine['ID']
    csvLine
  for directorDoc in directorDocs
    Directors.insert directorDoc

  eventDirectorsCsv = Assets.getText('event_directors.csv')
  eventDirectorsCsvLines = CsvReader.getLinesFromString(eventDirectorsCsv)
  for csvLine in eventDirectorsCsvLines
    eventId = csvLine['Event ID']
    directorId = csvLine['Director ID']
    Events.update
      _id: eventId
    ,
      $push:
        directorIds: directorId
    Directors.update
      _id: directorId
    ,
      $push:
        eventIds: eventId

