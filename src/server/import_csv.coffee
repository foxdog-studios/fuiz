Meteor.startup ->
  if Meteor.settings.resetOnStart
    Films.remove {}
  return if Films.find().count() > 0
  csv = Meteor.require('fast-csv')

  events = Assets.getText('events.csv')

  csvLines = []
  Async.runSync (done) ->
    csv
      .fromString(events, headers: true)
      .on 'record', (data) ->
        csvLines.push data
      .on 'end', ->
        done()

  # Cleaning up
  cleanedCsvLines = _.map csvLines, (csvLine) ->
    if csvLine['Year released'] != ''
      csvLine.yearReleased = csvLine['Year released']
    delete csvLine['Year released']
    csvLine.isLive = if csvLine['Live?'] > 0 then true else false
    delete csvLine['Live?']
    csvLine.isPreview = if csvLine['Preview?'] > 0 then true else false
    delete csvLine['Preview?']
    csvLine.certificate = csvLine['Certificate']
    delete csvLine['Certificate']
    csvLine

  # Meteor code must be run in fiber so do inserts after async code has run.
  for cleanedCsvLine in cleanedCsvLines
    Films.insert cleanedCsvLine

