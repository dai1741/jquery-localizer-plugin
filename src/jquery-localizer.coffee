(($) ->
  
  defOpts =
    langPath: '/'
    lang: 'auto'
    acceptableLangs: ['en', 'de', 'ja']
  
  class Localizer
    constructor: () ->
      @dics = {}
    
    # this will request "#{@opts.langPath}/#{@lang}.json"
    setLang: (lang) =>
      @lang = lang
      unless @dics[@lang]?
        $.getJson "#{@opts.langPath}/#{@lang}.json", (dic) ->
          @dics[@lang] = dic
      
      # @dics[@lang]
      $
    
    get: (key) =>
      @dics[@lang][key]
    
    init: (opts) =>
      @opts = $.extend(defOpts, opts)
      lang =
        if opts.lang is 'auto'
          navLang = navigator.language ? navigator.browserLanguage
          if navLang? and navLang isnt ''
            (l for l in @opts.acceptableLangs when l is navLang)?[0] ?
            (l for l in @opts.acceptableLangs when l.indexOf(navLang) == 0)?[0]
          else null
        else
          @opts.lang
      
      lang = @opts.acceptableLangs[0] unless lang in @opts.acceptableLangs
      # throw 'unsupported language'
      
      @setLang lang
      
      $
  
  $.extend
    localizer: new Localizer()
  
)(jQuery)