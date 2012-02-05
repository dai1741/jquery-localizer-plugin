sys = require 'sys'
exec = (require 'child_process').exec

filename = 'jquery-localizer'
file = 'src/jquery-localizer.coffee'

task 'compile', 'コンパイルします', (options) ->
  logger = (err, stdout, stderr) ->
    throw err if err
    console.log stdout+stderr if stdout or stderr
  
  exec "coffee -cj #{filename}.js #{file}", logger
  exec "uglifyjs #{filename}.js > #{filename}.min.js", logger