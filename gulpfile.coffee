gulp = require('gulp')
gutil = require('gulp-util')
uglify = require('gulp-uglify')
coffee = require('gulp-coffee')
coffeelint = require('gulp-coffeelint')
sourcemaps = require('gulp-sourcemaps')

# 文件路径
coffeescript_files = 'src/*.coffee'
build_dir = 'app'

# 任务列表
gulp.task 'validate_coffee', ->
  gulp.src coffeescript_files
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'compile_coffee', [ 'validate_coffee' ], ->
  gulp.src coffeescript_files
  .pipe sourcemaps.init()
  .pipe coffee bare: true
  # .pipe uglify()
  .pipe sourcemaps.write './'
  .on 'error', gutil.log
  .pipe gulp.dest build_dir

gulp.task 'watch', ->
  gulp.watch coffeescript_files, ['compile_coffee']

# 执行任务
gulp.task 'default', ['compile_coffee'], ->
  console.log 'run default task'

gulp.task 'dev', ['compile_coffee','watch'], ->
  console.log 'run dev task'
