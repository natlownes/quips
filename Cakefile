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
    sh "#{localBin}haml-coffee -i test -o tmp/templates.js"

task 'tags', 'ctags', (options, cb) ->
  sh 'ctags -R .'

mochaExec = ->
  "#{localBin}mocha"

option '-f', '--files [PATHS]', 'only run specific files'
option '-w', '--watch', 'watch'
task 'test', 'mocha tests', (options, cb) ->
  testDependencies = [
    "./test/setup.coffee"
    "./tmp/templates"
  ]

  files            = options.files || "./test"

  cmd = "node"
  mochaArgs = [
    mochaExec(),
    '-c'
    '--compilers'
    'coffee:coffee-script'
    '--recursive'
    '-u'
    'bdd'
  ]

  mochaArgs.push('-w') if options.watch?

  mochaArgs.push(filePath) for filePath in testDependencies
  mochaArgs.push(files)

  sh "cake haml:compile:test", ->
    mocha = spawn cmd, mochaArgs
    mocha.stdout.on 'data', (data) ->
      print data.toString()
    mocha.stderr.on 'data', (data) ->
      console.log data.toString()

