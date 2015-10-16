var gulp = require('gulp');
var less = require('gulp-less');
var path = require('path');
var exec = require('child_process').exec;

gulp.task('default', function() {
  // place code for your default task here
  gulp.start("Server");
});

gulp.task("Server", function() {
  console.log("Starting app in development.");
  exec("node index.js")
  var watcher = gulp.watch('./less/**', ['less Watch/Compile']);
  watcher.on('change', function(event) {
    console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
  });
});

gulp.task('less Watch/Compile', function () {
  console.log("Compiling less files, outputting to /css");
  return gulp.src('./less/**/*.less')
    .pipe(less({
      paths: [ path.join(__dirname, 'less', 'includes') ]
    }))
    .pipe(gulp.dest('./public/css'));
});
