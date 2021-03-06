moment = require 'moment'

date = (dateString) ->
  date = new Date(dateString)
  formattedDate = moment.utc(date).format('M/DD/YYYY')
  if formattedDate.indexOf('NaN') is -1
    formattedDate
  else
    ''

dateTime = (dateTimeString) ->
  date = new Date(dateTimeString)
  formattedDate = moment.utc(date).format('M/DD/YYYY h:mm A')
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

zipCode = (value) ->
  if value.toString().indexOf('-') > -1
    # ex: 19147-1234
    ("00000" + "#{value}".replace(/[^0-9-]/g, '')).slice(-10)
  else
    # ex: 19147
    ("00000" + "#{value}".replace(/[^0-9-]/g, '')).slice(-5)

number = (number) ->
  formatNumber(number, 0)

formatNumber = (number, places) ->
  s = if number < 0 then "-" else ""
  i = parseInt(number = Math.abs(+number || 0).toFixed(places)) + ""
  j = if (j = i.length) > 3 then j % 3 else 0

  return s + (if j then i.substr(0, j) + ',' else "") +
           i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + ',') +
           (if places then "." + Math.abs(number - i).toFixed(places).slice(2) else "")

modelNames = (models) ->
  names = (model.get('name') for model in models)
  if names.length < 3
    names.join(' and ')
  else
    "#{names[0...names.length-1].join(', ')}, and #{names[names.length-1]}"

module.exports =
  date:       date
  dateTime:   dateTime
  boolean:    boolean
  money:      money
  number:     number
  modelNames: modelNames
  zipCode:    zipCode
