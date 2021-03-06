$        = require 'jqueryify2'
_        = require 'underscore'
Backbone = require 'backbone'

events = require '../lib/events'


class View extends Backbone.View
  constructor: ->
    super

    if navigator?
      require '../lib/jquery.blockUI'

    @_childViews = []

  append: (item, $el = null) ->
    if $el is null
      $el = @$el

    if item.el?
      @_childViews.push item
      $el.append item.el
    else
      $el.append item

    this

  html: ->
    if arguments.length is 0
      return @$el.html()

    @$el.empty().append arguments...
    this

  remove: ->
    @unregister()
    v.remove() for v in @_childViews
    super

  populate: ->
    for selector, viewName of _.result(this, 'views')
      @$el.find(selector).append(@[viewName].el)

    for selector, field of @elements
      @[field] = @$(selector)

  block: (opts) ->
    if @_blockAvailable()
      blockOpts =
          message: opts?.message or 'Loading...'
          ignoreIfBlocked: true
          css:
            border: 'none'
            padding: opts?.css?.padding or '30px'
            backgroundColor: opts?.css?.backgroundColor or '#000'
            '-webkit-border-radius': '10px'
            '-moz-border-radius': '10px'
            opacity: opts?.css?.opacity or .7
            color: opts?.css?.color or '#fff'

      if opts?.local
        @$el.block(blockOpts)
      else
        $.blockUI(blockOpts)

  unblock: ->
    if @_blockAvailable()
      if @$el.find('.blockUI').length
        @$el.unblock()
      else
        $.unblockUI()

  template: ->
    @_templateChoice()(arguments...)

  _templateChoice: ->
    if @_template?.charAt?
      # _template is set as a path
      if not window.HAML[@_template]?
        throw new Error(
          "couldn't find template at #{@_template}"
        )
      return window.HAML[@_template]

    if @_template?.call?
      # _template is a function
      return @_template
    # didn't find either, empty string
    (-> '')

  render: =>
    if @model?
      @html @template(@model.json())
    else
      @html @template()
    @populate()
    @_focusFirst()
    this

  _focusFirst: ->
    _.defer(=> @$el.find('input:text').filter(':visible').first().focus())

  _blockAvailable: ->
    $.blockUI?


module.exports = events.track View
