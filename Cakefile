sys = require 'sys'
exec = (require 'child_process').exec

filename = 'jquery-localizer'
files = [
  'src/jquery-localizer.coffee'
]

task 'compile', 'コンパイルします', (options) ->
  logger = (err, stdout, stderr) ->
    throw err if err
    console.log stdout+stderr if stdout or stderr
  
  exec "coffee -cj #{filename}.js #{files.join ' '}", () ->
    logger.apply this, arguments
    exec "uglifyjs #{filename}.js > #{filename}.min.js", logger
