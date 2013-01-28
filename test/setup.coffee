process.env.TZ = 'EST'

jsdom = require('jsdom').jsdom
global.document or= jsdom()
global.window   or= global.document.createWindow()

global.window.confirm  = -> true
global.jQuery          = require 'jqueryify2'
global.jQuery.contains = -> true
global.chai = require 'chai'


Backbone        = require 'backbone'
MockHttpServer  = require('./lib/mock_server').MockHttpServer



class TestState

  destroy: ->
    module.exports.destroy()


module.exports =
  create: ->
    @_setup()
    @patterns = []
    global.window.confirm = -> true
    new TestState

  destroy: ->
    @server.stop()

  when: (method, url, respond) ->
    @patterns.push [method, url, respond]

  fail: ->
    throw new Error(arguments...)

  _setup: ->
    Backbone.$ = jQuery

    ext  = require './lib/chai_extensions'
    chai.use(ext)

    @server = new MockHttpServer (req) => @_handleRequest req
    @server.start()

  _handleRequest: (request) ->
    handed = false

    for [method, url, respond] in @patterns
      if method is request.method and url is request.url
        resp = respond(request) or {}
        resp.status   or= 200
        resp.body     or= ''

        request.receive resp.status, resp.body
        handed = true

    unless handed
      request.receive 404, 'Not Found'
