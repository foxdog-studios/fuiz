Meteor.startup ->
  if Meteor.settings.resetOnStart
    Films.remove {}
  return if Films.find().count() > 0
  csv = Meteor.require('fast-csv')

  films = Assets.getText('films.csv')

  csvLines = []
  Async.runSync (done) ->
    csv
      .fromString(films, headers: true)
      .on 'record', (data) ->
        csvLines.push data
      .on 'end', ->
        done()

  # Cleaning up
  cleanedCsvLines = _.map csvLines, (csvLine) ->
    if csvLine.Year != ''
      csvLine.year = csvLine.Year
    delete csvLine.Year
    csvLine

  # Meteor code must be run in fiber so do inserts after async code has run.
  for cleanedCsvLine in cleanedCsvLines
    Films.insert cleanedCsvLine

