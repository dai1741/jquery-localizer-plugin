(($) ->
  
  defOpts =
    langPath: './'
    lang: 'auto'
    acceptableLangs: ['en', 'de', 'ja']
    reuseDics: yes
  
  class DicLoader
    constructor: () ->
      @dics = {}
    
    loadDic: (langPath, lang, suc) =>
      $.ajax
        url: "#{langPath}/#{lang}.json"
        success: (dic) =>
          @dics[lang] = dic
        error: (req, st) ->
          # hmmmm
    
    getOrLoadDic: (langPath, lang) =>
      @dics[lang] ? loadDic langPath, lang
    
    hasDic: (lang) =>
      @dics[lang]?
  
  class Localizer
    constructor: () ->
      @dics = {}
    
    # this will request "#{@opts.langPath}/#{@lang}.json"
    setLang: (lang) =>
      @lang = lang
      unless @dics[@lang]?
        $.ajax
          url: "#{@opts.langPath}/#{@lang}.json"
          success: (dic) =>
            @dics[@lang] = dic
            null
          error: (req, st) ->
            # hmmmm
      
      # @dics[@lang]
      $
    
    get: (key) =>
      @dics[@lang]?[key]
      
    getLastCachedDic: () =>
      @dics[@lang]
      
    getCachedDics: () =>
      @dics
    
    init: (elm, opts) =>
      @opts = $.extend(defOpts, opts)
      lang =
        if @opts.lang is 'auto'
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
    _localizerDicLoader: new DicLoader()
  
)(jQuery)