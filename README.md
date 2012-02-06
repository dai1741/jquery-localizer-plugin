jQuery Localizer Plugin
========================

とてもシンプルな多言語切り替えプラグイン。  
高度な用途では[jQuery UI Globalize](https://github.com/jquery/globalize)を使ったほうが便利だと思います。

使い方
------

次の1行を実行すると、`localize-[key]`というクラス名を持つ要素の中身がJSONファイルで定義する言語ごとの辞書の`key`というハッシュキーに対応する文章に置き換わる。

    $('body').localize();

具体的には次のようにすると、`div.localize-key`の中身が *値* または *Value* となる。

test.html:

    <script>
    $(document).ready(function() {
        $('body').localize({
            acceptableLangs: ['ja', 'en']
        });
    });
    </script>
    
    <div class="localize-key"></div>

ja.json:

    {
        "key": "値"
    }

en.json:

    {
        "key": "Value"
    }

オプション
----------

* langPath
  * json形式の言語ファイルのHTMLからの（相対）位置
* lang
  * 言語。`auto`の場合、ブラウザの言語によって判定。
* acceptableLangs
  * `lang`の値として認められるもののリスト。ここに含まれるすべての言語ファイルを用意する必要がある。
* classPrefix
  * 文字列を言語別に置き換えるクラス名の接頭辞
* reuseDics
  * 言語ファイルをキャッシュするかどうか
* success
  * 多言語置き換え成功時のコールバック関数
* error
  * 多言語置き換え失敗時のコールバック関数
* complete
  * 多言語置き換え完了時のコールバック関数



Defaults:


    $('body').localize({
        langPath: './',
        lang: 'auto',
        acceptableLangs: ['en', 'de', 'ja'],
        classPrefix: 'localize-',
        reuseDics: true,
        success: $.noop,
        error: $.noop,
        complete: $.noop
    });

ビルド
------

プロジェクトのルートディレクトリで、以下のコマンドを入力してください。

    cake compile

ビルドには以下のコマンドを実行できる環境が必要です。

* node
* coffee
* uglifyjs
