(($) ->
  
  defOpts =
    langPath: './'
    lang: 'auto'
    acceptableLangs: ['en', 'de', 'ja']
    classPrefix: 'localize-'
    reuseDics: yes
    success: $.noop
    error: $.noop
    complete: $.noop
  
  class DicLoader
    constructor: () ->
      @dics = {}
    
    loadDic: (langPath, lang, onload) =>
      $.ajax
        url: "#{langPath}/#{lang}.json"
        dataType: 'json'
        success: (dic) =>
          @dics[lang] = dic
          null
        error: (req, st) ->
          # hmmmm
        complete: () =>
          onload(@dics[lang])
    
    getOrLoadDic: (langPath, lang, onload) =>
      if @dics[lang]? 
        onload()
        @dics[lang]
      else
        @loadDic langPath, lang
  
  dicLoader = new DicLoader()
  
  class Localizer
    
    constructor: (@elm, opts) ->
      @opts = $.extend(defOpts, opts)
      @update @opts
    
    setLangAndLoadDic: (lang, onload) =>
      @lang = lang
      (if @opts.reuseDic
          dicLoader.getOrLoadDic
        else
          dicLoader.loadDic)(@opts.langPath, @lang, (dic) =>
            @dic = dic
            onload()
        )
    
    get: (key) =>
      @dic?[key]
    
    getLang: () =>
      @lang
    
    update: (opts) =>
      @opts = $.extend(@opts, opts)
      lang =
        if @opts.lang is 'auto'
          navLang = navigator.language ? navigator.browserLanguage
          if navLang? and navLang isnt ''
            (l for l in @opts.acceptableLangs when l is navLang)?[0] ?
            (l for l in @opts.acceptableLangs when l.indexOf(navLang) == 0)?[0]
        else
          @opts.lang
      
      lang = @opts.acceptableLangs[0] unless lang in @opts.acceptableLangs
      
      @setLangAndLoadDic lang, () =>
        @updateDOM()
        if @dic?
          @opts.success?()
          @elm.trigger('localizesuccess')
        else
          @opts.error?()
          @elm.trigger('localizeerror')
        @opts.complete?()
        @elm.trigger('localizecomplete')
    
    updateDOM: () =>
      @elm.find("*[class^=#{@opts.classPrefix}]").each (i, e) =>
        me = $(e)
        key = (cl for cl in me.attr('class').split(/\s+/) when cl.
          indexOf(@opts.classPrefix) == 0)[0]?.slice @opts.classPrefix.length
        me.text(@dic[key] ? '')  # if key?
        null
  
  $.fn.localize = (arg) ->
    if $.type(arg) is 'string'
      # arg represents a key of the cached dictionary
      @eq(0)?.data('localizerCache')?.get(arg)
    else
      # arg probably represents options object
      @each () ->
        me = $(@)
        cache = me.data('localizerCache')
        if cache?
          cache.update(arg)
        else
          me.data('localizerCache', new Localizer(me, arg))
        null
  
)(jQuery)