Meteor.startup ->
  if Meteor.settings.resetOnStart
    Events.remove {}
    Directors.remove {}
  return if Events.find().count() > 0

  # Meteor code must be run in fiber so do inserts after async code has run.

  eventDocs = _.map CsvReader.getLinesFromAsset('events.csv'), (csvLine) ->
    # Cleaning up
    csvLine.title = csvLine.Title
    delete csvLine.Title
    if csvLine['Year released'] != ''
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

  directorDocs = _.map CsvReader.getLinesFromAsset('directors.csv'), (csvLine) ->
    csvLine.name = csvLine['Name']
    delete csvLine['Name']
    csvLine._id = csvLine['ID']
    delete csvLine['ID']
    csvLine
  for directorDoc in directorDocs
    Directors.insert directorDoc

  eventDirectorsCsvLines = CsvReader.getLinesFromAsset('event_directors.csv')
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

  movieDbCsvLines = CsvReader.getLinesFromAsset('moviedblinks.csv')
  for csvLine in movieDbCsvLines
    eventId = csvLine.ID
    theMovieDbId = csvLine.tmdb_id
    continue if not theMovieDbId? or theMovieDbId == ''
    Events.update
      _id: eventId
    ,
      $set:
        theMovieDbId: theMovieDbId

