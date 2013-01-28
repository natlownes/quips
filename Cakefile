fs                  = require 'fs'
{spawn, exec}       = require 'child_process'
{log, error, print} = require 'util'
localBin = "./node_modules/.bin/"

sh = (cmd, cb) ->
  proc = exec cmd, (err, stdout, stderr) ->
    process.stdout.write stdout if stdout
    process.stderr.write stderr if stderr
    throw err if err
    process.exit proc.exitCode if proc.exitCode
    cb? proc

task 'dev:server', 'run frontend and mock backend', ->
  server = sh 'coffee dev_server.coffee'
  # TODO
  frontend = sh ''

task 'clean:test', 'clean tmp dir', (options, cb) ->
  sh 'rm -rf tmp/*'

task 'haml:compile:test', 'compile haml templates', (options, cb) ->
  sh 'cake clean:test', ->
    sh "haml-coffee -i test -o tmp/templates.js"

task 'tags', 'ctags', (options, cb) ->
  sh 'ctags -R .'

mochaCommand = ->
  "./node_modules/.bin/mocha
    -c
    --compilers coffee:coffee-script "

option '-f', '--files [PATHS]', 'only run specific files'
option '-w', '--watch', 'watch'
task 'test', 'mocha tests', (options, cb) ->
  testDependencies = "./test/setup.coffee ./tmp/templates.js"
  files            = options.files || "./test/**/*_spec.coffee"
  reporter         = if options.watch
    'dot'
  else
    'spec'

  optionsFlag = if options.watch
    '-w '
  else
    ' '

  cmd = "#{mochaCommand()}
    -u bdd
    -R #{reporter}
    #{optionsFlag}
    #{testDependencies} #{files}"

  sh "cake haml:compile:test", ->
    sh "#{cmd}"

task 'test:watch', 'watch tests', (options, cb) ->
  testDependencies = "./test/setup.coffee ./tmp/templates.js"
  files            = options.files || "./test/**/*_spec.coffee"

  cmd = "#{mochaCommand()}
    -u bdd
    -w
    -R dot
    #{testDependencies} #{files}"
  print cmd

  sh "#{cmd}"
