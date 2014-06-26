class @CsvReader
  @getLinesFromAsset: (assetName) ->
    csv = Assets.getText(assetName)
    CsvReader._getLinesFromString(csv)

  @_getLinesFromString: (string) ->
    csv = Meteor.require('fast-csv')
    csvLines = []
    Async.runSync (done) ->
      csv
        .fromString(string, headers: true)
        .on 'record', (data) ->
          csvLines.push data
        .on 'end', ->
          done()
    csvLines

