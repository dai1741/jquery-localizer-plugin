(($) ->
  
  defOpts =
    langPath: './'
    lang: 'auto'
    acceptableLangs: ['en', 'de', 'ja']
    classPrefix: 'localize-'
    reuseDics: yes
  
  class DicLoader
    constructor: () ->
      @dics = {}
    
    loadDic: (langPath, lang) =>
      $.ajax
        url: "#{langPath}/#{lang}.json"
        success: (dic) =>
          @dics[lang] = dic
        error: (req, st) ->
          # hmmmm
      @dics[lang]
    
    getOrLoadDic: (langPath, lang) =>
      @dics[lang] ? @loadDic langPath, lang
    
    hasDic: (lang) =>
      @dics[lang]?
  
  dicLoader = new DicLoader()
  
  class Localizer
    
    # this will request "#{@opts.langPath}/#{@lang}.json"
    setLangAndLoadDic: (lang) =>
      @lang = lang
      @dic = (if @opts.reuseDic
          dicLoader.getOrLoadDic
        else
          dicLoader.loadDic)(@opts.langPath, @lang)
      
      $
    
    get: (key) =>
      @dic?[key]
    
    getLang: () =>
      @lang
    
    constructor: (@elm, opts) ->
      @opts = $.extend(defOpts, opts)
      @update @opts
    
    update: (opts) =>
      @opts = $.extend(@opts, opts)
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
      
      @setLangAndLoadDic lang
      
      @updateDOM()
      
      $
    
    updateDOM: () =>
      @elm.find("*[class^=#{@opts.classPrefix}]").each (i, e) =>
        me = $(e)
        key = (cl for cl in me.attr('class').split(/\s+/) when cl.
          indexOf(@opts.classPrefix))[0]?.slice @opts.classPrefix.length
        me.text(@dic[key] ? '')  # if key?
        null
  
  $.fn.localize = (opts) ->
    @each () ->
      me = $(@)
      cache = me.data('localizerCache')
      if cache?
        cache.update(opts)
      else
        me.data('localizerCache', new Localizer(me, opts))
      null
  
)(jQuery)