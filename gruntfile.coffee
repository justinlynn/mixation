module.exports = (grunt) ->

  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')

    browserify:
      standalone:
        src: [ './src/mixation.coffee' ]
        dest: './build/mixation.standalone.js'
        options:
          bundleOptions:
            standalone: 'mixation'
      require:
        src: [ './src/mixation.coffee' ]
        dest: './build/mixation.require.js'
        options:
          alias: [ './src/mixation.coffee:' ]
      specs:
        src: [ './spec/suites.coffee' ]
        dest: './build/mixation.specs.js'
        options:
          debug: true, # embed source maps
          alias: [ './src/mixation.coffee:mixation' ]

    coffeelint:
      lib: ['src/**/*.coffee']
      spec: ['spec/**/*.coffee']
      options:
        configFile: '.coffeelintrc'

    connect:
      server: {}

    mocha_phantomjs:
      all:
        options:
          urls: ['http://127.0.0.1:8000/spec/runner.html']

    simplemocha:
      options:
        globals: ['should', 'mocha']
        timeout: 3000
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      all:
        src: ['node_modules/should/should.js', 'build/mixation.require.js', 'build/mixation.specs.js']

    uglify:
      dist:
        files:
          'build/mixation.min.js': ['<%= browserify.standalone.dest %>']
  )

  [ 'grunt-browserify',
    'grunt-contrib-uglify',
    'grunt-contrib-connect',
    'grunt-mocha-phantomjs',
    'grunt-contrib-coffee',
    'grunt-coffeelint',
    'grunt-simple-mocha'
  ].forEach (dependency) -> grunt.loadNpmTasks(dependency)

  grunt.registerTask 'default', [
      'coffeelint', # ensure our coffeescript is sane
      'browserify', # convert coffee to JS, add in require shims, etc
      'uglify', # minify scripts
      'simplemocha', # run specs in nodejs
      'connect', # start webserver for headless browser
      'mocha_phantomjs' # run specs in headless browser
    ]
