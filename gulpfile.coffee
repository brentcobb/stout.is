bower      = require 'gulp-bower'
browserify = require 'browserify'
buffer     = require 'gulp-buffer'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
connect    = require 'gulp-connect'
fs         = require 'fs'
gulp       = require 'gulp'
gulpif     = require 'gulp-if'
gutil      = require 'gulp-util'
jade       = require 'gulp-jade'
nib        = require 'nib'
Path       = require 'path'
replace    = require 'gulp-replace'
source     = require 'vinyl-source-stream'
stylus     = require 'gulp-stylus'
uglify     = require 'gulp-uglify'

handleError = (err) ->
  gutil.log err
  gutil.beep()

  @emit 'end'

  process.exit(1)

STYLUS_OPTS =
  use: [nib()]
  errors: true
  paths: [
    __dirname
    Path.join(__dirname, 'bower_components')
  ]

gulp.task 'js', ->
  browserify({
    entries: [
      './coffee/app.coffee'
    ]
    extensions: ['.coffee']
  })
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest('./build/js'))

gulp.task 'css', ->
  gulp.src('./styl/**/*.styl')
    .pipe(stylus(STYLUS_OPTS))
      .on('error', handleError)
    .pipe(gulp.dest('./build/css'))

gulp.task 'html', ->
  gulp.src('./jade/**/*.jade')
    .pipe(jade().on('error', handleError))
    .pipe(gulp.dest('./build'))

gulp.task 'images', ->
  gulp.src('./images/**/*')
    .pipe gulp.dest('./build/images')

gulp.task 'watch', ->
  gulp.watch ['./coffee/**'], ['js']
  gulp.watch ['./styl/**'], ['css']
  gulp.watch ['./jade/**'], ['html']

gulp.task 'connect', ->
  connect.server
    root: ['build']
    port: 9005
    livereload:
      port: 35131
    connect:
      redirect: false

gulp.task 'build', [
  'js'
  'css'
  'html'
  'images'
]

gulp.task 'default', [
  'build'
  'watch'
  'connect'
]
