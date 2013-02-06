module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-coffee-server')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-browserify')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('test', ['testcompile', 'mocha'])
  grunt.registerTask('pkg', ['clean', 'browserify:pkg'])
  grunt.registerTask('haml:compile:test', ['shell:haml_compile_test'])

  grunt.registerTask('testcompile', [
    'haml:compile:test'
    'coffee:spec',
    #'copy:libspec',
    'copy:htmlrunner',
    'copy:mocha',
    'copy:chai',
    'copy:rack'
  ])

  buildDir  = 'pkg'

  appCoffeeFiles = [
    'models/*.coffee',
    'collections/*.coffee',
    'controllers/*.coffee',
    'views/*.coffee',
    'lib/*.coffee',
    'quips.coffee'
  ]

  templateFiles = [
    'test/**/*.haml'
  ]

  appTestFiles = [
    'test/**/*.coffee'
  ]

  testHarness = [
    'test/runner.html'
  ]

  grunt.initConfig
    pkg: '<json:package.json>',
    meta:
      banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'
    clean:
      folder: ["<%= pkg.dist %>", "tmp", "pkg"]
    shell:
      haml_compile_test:
        command: 'haml-coffee -i test -o tmp/templates.js'
        stdout: true
    copy:
      libsrc:
        files:
          'pkg/lib/': 'lib/*.js'
      libspec:
        files:
          'tmp/lib/': 'lib/*.js'
          'tmp/test/': 'test/**/*.js'
      htmlrunner:
        files:
          'tmp/runner.html': 'test/runner.html'
      mocha:
        files:
          'tmp/mocha.js': 'node_modules/mocha/mocha.js'
          'tmp/mocha.css': 'node_modules/mocha/mocha.css'
      chai:
        files:
          'tmp/chai.js': 'node_modules/chai/chai.js'
      rack:
        files:
          'tmp/config.ru': 'config.ru'
    watch:
      test:
        files: appCoffeeFiles.concat(appTestFiles).concat(testHarness)
        tasks: ['testcompile']
      templates:
        files: templateFiles
        tasks: ['haml:compile:test']
        options:
          interrupt: true
    browserify:
      pkg:
        aliases: ['jquery-browserify:jqueryify2']
        src: appCoffeeFiles
        dest: 'pkg/quips.js'
      test:
        aliases: [
          'jquery-browserify:jqueryify2'
          #'chai:chai/chai',
          #'mocha/mocha:mocha'
        ]
        src: appCoffeeFiles.concat(appTestFiles)
        dest: 'tmp/quips.js'
    coffee:
      options:
        bare: true
      src:
        files:
          'pkg/quips/*.js': appCoffeeFiles
      spec:
        files:
          'tmp/*.js': [
            'test/**/*.coffee'
          ].concat(appCoffeeFiles)
        flatten:
          options:
            flatten: true
          #files:
            #'path/to/*.js': []
