const gulp    = require("gulp")
const haml    = require("gulp-haml")
const del     = require("del")
const concat  = require("gulp-concat")
const moon    = require("gulp-moonscript")
const run     = require("gulp-run-command").default
const watch   = require("gulp-watch")

gulp.task("clean", function() {
  return del(["./build", "./temp", "./docs"])
})

gulp.task("moon", ["clean"], function() {
  return gulp.src("./src/**/*.moon")
    .pipe(moon())
    .pipe(gulp.dest("./build/"))
})

gulp.task("build", ["moon"])

gulp.task("docs", ["build"], run([
  "mkdir -p docs",
  "naturaldocs -i src -o html docs -p .ndocs"
]))

gulp.task("watch", function() {
  return watch("src/**/*.moon", {ignoreInitial: false})
    .pipe(moon())
    .pipe(gulp.dest("./build/"))
})

gulp.task("default", ["build"])
