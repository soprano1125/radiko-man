# radiko-man
## 概要
radiko.jp 聴取/録音スクリプト。

## ファイル内容
    + radiko-man
        - pl                  ; Perl 版(rtmp)
            - login           ; プレミアム ログイン
            - logout          ; プレミアム ログアウト
            - makeKey         ; rtmpdump で使う token 取得
            - checkArea       ; エリア判定
        - hls                 ; Perl 版(hls)
            - login           ; プレミアム ログイン
            - logout          ; プレミアム ログアウト
            - makeKey         ; ffmpeg で使う token 取得
            - checkArea       ; エリア判定
        - sh                  ; シェルスクリプト版
            - login           ; プレミアム ログイン
            - logout          ; プレミアム ログアウト
            - makeKey         ; rtmpdump で使う token 取得
            - checkArea       ; エリア判定
        - common              ; 共通ファイル
            - checkIPArea     ; 非会員用エリア判定
            - checkPaidMember ; プレミアムログイン確認
            - makeUserAgent   ; User-Agent
            - getParam        ; ini ファイルのパラメータ取得
            - getDuration     ; hls から取得する場合時間を変換する際に使用
            - getRadioStation ; Station ID から放送局を取得
            - getStreamParam  ; Station ID から録音パラメータを取得
            - base.sh         ; 共通設定
        - check-tool          ; ツールインストール確認
        - radiko.ini          ; 設定ファイル
        - radiko_download.sh  ; radiko の音声取得用
        - radiko_live.sh      ; VLC 聴取用
        - radiko_mp3.sh       ; 取得した音声を mp3 にエンコードして保存する
        - radiko_noenc.sh     ; 取得した音声を flv のまま保存する
        - README.md           ; このファイル

## 依存パッケージ
* ツール系
   * rtmpdump
   * swftools
   * sudo(管理者権限でないとファイルを保管できない場合)
   * ffmpeg(mp3 エンコードする場合, hls から取得する場合は必須)
      * libavcodec-extra-53(mp3 エンコードする場合は必須)
      * 特に hls から取得する場合はバージョンが古かったりモジュールが足りなかったりすると取得できない可能性があります
      * Ubuntu trusty 以降は PPA を用いてインストールしないとダメかもしれない
   * vlc(聴取のみの場合は必須)
* Perl パッケージ
   * Config::Simple;
   * File::Spec;
   * Unicode::Japanese;
   * Encode;
   * JSON;
   * LWP::UserAgent;
   * XML::Simple;
   * MIME::Base64;

## 使い方
1. check-tool をそれぞれ実行してエラーが出力されないことを確認する
1. radiko.ini の｢auth_mail｣､｢auth_pass｣を自分の環境に合わせて設定する｡
1. radiko-man/*.sh に記載している HOME_PATH, PROG_PATH, TEMP_PATH, OUT_DIR を環境に応じて設定する｡
1. 使用する radiko-man/*.sh の動作確認を行う｡
  * radiko_mp3.sh, radiko_noenc.sh にそれぞれ 引数として｢放送局のステーション ID｣、｢録音時間｣、｢プレミアムモード｣をそれぞれ指定して実行する｡
  * radiko_live.sh は引数として｢放送局のステーション ID｣、｢バッファ時間｣、｢プレミアムモード｣を指定して実行する｡
```
$ ./radiko_noenc.sh channel_name rec_time premium_mode<free,premium> [outputfile]
$ ./radiko_mp3.sh channel_name rec_time premium_mode<free,premium> [outputfile]
$ ./radiko_live.sh channel_name [premium_mode<free,premium>]
```

## 引数の解説
+ radiko_mp3.sh, radiko_noenc.sh, radiko_live.sh
   + `channel_name` : 録音する放送局の ID
   + `rec_time` : 録音時間(秒)　radiko_live.sh　で使うことはまぁないでしょう
   + `premium_mode` : プレミアム会員で録音する場合は premium, そうでない場合は free
   + `outputfile` : (あれば)番組名
+ radiko.ini
   + premium
       + `auth_mail`: メールアドレス
       + `auth_pass`: パスワード
       + `auth_url`:  認証URL
       + `auth_key`:  認証コード保管ファイル
       + `cookie_file`: Cookie 保管ファイル
   + common
       + `owner`: エンコードファイルの所有者(管理者権限でないとファイルを保管できない場合)
       + `prog_mode`: プログラムモード指定 shell の場合は sh, Perl の場合は pl, hls の場合は hls
       + `player_ver`: player.swf のバージョンナンバー
       + `player_url`: player.swf のURL
       + `playerJS_url`: key
       + `server`: rtmp サーバーのアドレス
       + `play_path`: playpath
       + `application`: rtmp サーバーのアドレス
       + `area_file`: エリア判定保管ファイル
       + `api_url`: API アドレス
       + `http_timeout`: HTTP でのタイムアウト値
       + `mozilla_agent`: Mozila のバージョン
       + `user_agent`: radiko-man のバージョン

## その他
* README と(ファイル構成や設定ファイルの中身が)なんかちがくない?
   * 「よくある話」として気にしないでやってください。
   * これを書いた人は基本ものぐさなので忘れてることが多いです。
   * 気になる方はコミットログを参照してね!(ぉぃ
* Fork していい?
   * どうぞどうぞ(上島メソッド 
   * でも Fork した後、どこか手を加えて何か起こった場合は自己責任でね。
* あれ?聴けないよ?
   * パッケージとか足りてます?
      * 足りてない→まずパッケージを入れよう、話はそれからだ
      * 足りてるねぇ→その時は周りも(このリポジトリの人も)聴けてないと思います。慌てず騒がず対応を待ったりググったりしてください。
* Windows でもできる?
   * 基本的に Bash と Perl が動けば多分いけるんじゃないですか?(未確認)
   * というか誰かが Windows　バイナリで作ったらいいんじゃ(素
* タイムシフト(タイムフリー)の機能はないの?
   * 一応準備はしていますがまだ「実証実験」なので入れていません。
   * と言っても認証方法は rtmp, hls の方法と同じみたいなので誰かが(ry
* なぜに Perl?
   * Shell だと wget で中間ファイルを生成しなくてはいけないのでそれをなるべく省きたかったのが一番の理由です。
   * あと手元で簡単に動かせられる環境が Perl だったのも(真顔
* Shell と Perl 両方入れてるのはどうして?
   * 問題が起こった時の切り分け用です。
   * ぶっちゃけ「Shell の方は切ってもよくね?」と思うところですがものぐさなので(ry

## 関連リンク
+ [radiko.jp](http://www.radiko.jp)
+ [簡易radiko録音ツール。要swftools](https://gist.github.com/saiten/875864)
    + [KOYAMA Yoshiaki のブログ](http://kyoshiaki.hatenablog.com/entry/2014/05/04/184748 "簡易 radiko.jp プレミアム対応 Radiko 録音スクリプト rec_radiko2.sh 公開。")
+ [uru2/rec_radiko_live: Radiko Live program recorder](https://github.com/uru2/rec_radiko_live)
+ [radiko 参加放送局一覧](http://www.dcc-jpl.com/foltia/wiki/radikomemo "radikomemo - foltia - Trac")

