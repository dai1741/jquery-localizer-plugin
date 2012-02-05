sys = require 'sys'
exec = (require 'child_process').exec
{parser, uglify} = require 'uglify-js'
fs = require('fs')

filename = 'jquery-localizer'
file = 'src/jquery-localizer.coffee'

task 'compile', 'コンパイルします', (options) ->
  logger = (err, stdout, stderr) ->
    throw err if err
    console.log stdout+stderr if stdout or stderr
  
  exec "coffee -cpj #{filename}.js #{file}", (err, stdout, stderr) ->
    throw err if err
    console.log stderr if stderr
    finalCode = uglify.gen_code uglify.ast_squeeze uglify.ast_mangle parser.parse stdout
    fs.writeFile "#{filename}.min.js", finalCode, logger