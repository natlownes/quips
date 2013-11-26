moment = require 'moment'

commafy = (value) ->
  value.toString().replace /(^|[^\w.])(\d{4,})/g, ($0, $1, $2) ->
    $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,")

date = (dateString) ->
  date = new Date(dateString)
  formattedDate = moment(date).format('M/D/YYYY')
  if formattedDate.indexOf('NaN') is -1
    formattedDate
  else
    ''
dateTime = (dateTimeString) ->
  date = new Date(dateTimeString)
  formattedDate = moment(date).format('M/D/YYYY h:mm A')
  if formattedDate.indexOf('NaN') is -1
    formattedDate
  else
    ''
boolean = (value) ->
  if not value?
    ' - '
  else if value
    'Yes'
  else
    'No'

money = (number) ->
  "$#{formatNumber(number, 2)}"

dollars = (number) ->
  "$#{formatNumber(number, 0)}"

zipCode = (value) ->
  if value.toString().indexOf('-') > -1
    # ex: 19147-1234
    ("00000" + "#{value}".replace(/[^0-9-]/g, '')).slice(-10)
  else
    # ex: 19147
    ("00000" + "#{value}".replace(/[^0-9-]/g, '')).slice(-5)

number = (number) ->
  formatNumber(number, 0)

decimalNumber = (number) ->
  formatNumber(number, 2)

formatNumber = (number, places) ->
  commafy((parseFloat(number) or 0).toFixed(places))

modelNames = (models) ->
  names = (model.get('name') for model in models)
  if names.length < 3
    names.join(' and ')
  else
    "#{names[0...names.length-1].join(', ')}, and #{names[names.length-1]}"

percentage = (number) ->
  number = parseFloat(number).toFixed(2)
  "#{number * 100.0}%"


module.exports =
  boolean:        boolean
  commafy:        commafy
  date:           date
  dateTime:       dateTime
  decimalNumber:  decimalNumber
  dollars:        dollars
  modelNames:     modelNames
  money:          money
  number:         number
  percentage:     percentage
  zipCode:        zipCode
