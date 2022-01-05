# Tokumemo

[![License: MIT](https://img.shields.io/github/license/akidon0000/univIP)](https://github.com/akidon0000/univIP/blob/main/LICENSE)
   
<p align="center" >
  <img src="/univIP/App/etc/Assets.xcassets/AppIcon.appiconset/1024.png" width=300px>
</p>

# 概要
トクメモは日々のパスワード入力、煩雑なボタンクリックを自動化する、徳島大学専用の学修サポートアプリです。
画面タップ回数をログイン時は3回->0回、成績参照時は11回->2回にまで減少させるなど学生の視点からあったらいいなを実現したアプリです。

#

## スクリーンショット
<img src="https://github.com/akidon0000/univIP/blob/develop/univIP/App/etc/Assets.xcassets/TutorialImage1.imageset/TutorialImage1.jpg" width="320px"><img src="https://github.com/akidon0000/univIP/blob/develop/univIP/App/etc/Assets.xcassets/TutorialImage2.imageset/TutorialImage2.jpg" width="320px"><img src="https://github.com/akidon0000/univIP/blob/develop/univIP/App/etc/Assets.xcassets/TutorialImage3.imageset/TutorialImage3.jpg" width="320px">

<img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_courceManagementMobile.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_manabaPC.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_mail.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_library.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_syllabus.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_libraryCalendar.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_setting1.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_setting2.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_password.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_career.png" width="320px">

## 仕様

## ライブラリ
- R.swift 
- Firebase/Analytics
- KeychainAccess // KeychainをUserDefautsのように操作するOSS
- Kanna // WebスクレイピングのOSS
- EAIntroView // ウォークスルー型チュートリアル生成のOSS
- Gecco // スポットライト型チュートリアル生成のOSS

## 機能一覧
- 教務事務システム、マナバ、outlookへの自動ログイン機能
- 時間制限による強制ログアウト対応
- カスタマイズメニューから大学のWebサービスへ遷移
- 図書館開館カレンダー、今期の成績について、動的URLをWebスクレイピング等をすることで取得し、表示
- シラバスの簡略検索
- メニューのカスタマイズ
- チュートリアルの表示

## 工夫点
毎日利用しやすいように工夫を重ねた。

### 1, タップ回数削減
学生の立場から使いやすい操作手順（タップ回数削減）に変更した。
例えば、「ログインするのに必要だったタップ回数を3回から0回へ」「成績参照までを11回から2回へ」など他にも工夫を重ねた。

### 2, 再ログイン機能
時間制限による強制ログアウトでエラーが発生し、改めてログインする必要があり面倒だったのを、自動でエラー回避した上でログインする様にした。

### 3, パスワード保存への信頼性
アプリの透明性をアピールする為、また同じ大学の仲間からアドバイスが受けられる様に、GitHubで公開した。
また、徳島大学イノベーションプラザの大学公認プロジェクトとして、広めれるよう現在調整中。

### 4, CI(継続的インテグレーション)の構築
GitHubActionsを使用し、XcodeのUnitTestを「main,develop」へプッシュされるたびに実行するように環境を整えた。

### 5, 保守性の向上
オープンソース、チーム開発をする上で、
コードの読みやすさ、言語やフレームワークの文化に沿ったコーディングスタイルを意識した。
また、適度にコメントを増やし3ヶ月後の自分でもわかる様、可読性を意識した。

### 6, コミットの粒度
正解の粒度はわからないが、自分自身がGitTreeを見た時に、何を変更したのかを理解できることを意識してコミットを行った。

### 7, 広報
認知度を広める為に、Twitterアカウントを稼働させた。
稼働後からの「トクメモ」ダウンロード数はこれにより向上した。
それ以外にも、ビラを作成し学内掲示板への掲示を行う予定。
https://twitter.com/tokumemo0000


## 自己評価
リリース日(2021年9月2日)
リリースから数ヶ月が経過した。
初期に比べて、UI面ではシンプルなアプリに。
コード面でもコードリーディングを意識し続けている為、わかりやすいコードになっているのではないかと考える。

また、FireBase/Analyticsを導入した結果、毎日２〜7ユーザーが利用してくれている為、
使いやすいアプリとして認知されているのではないかと考える。

今後も、ユーザーから意見を求めて積極的に改善していきたいと思う。


## 今後していきたい事
- 徳島大学イノベーションプラザのプロジェクト申請
- 他学生が運営しているWebサイトとの連携
- Android版の開発
- お問合せフォームの作成(APIの作成)
- iPadのサイズ対応
- 単体テスト等の充実 


---

# ライセンス

© 2021 akidon0000

トクメモは[MITライセンス](https://github.com/akidon0000/univIP/blob/main/LICENSE)のオープンソースプロジェクトです。

## オープンソース
本プロジェクトにご協力いただける方はWikiを参照してください。
