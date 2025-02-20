# インキャ眼

## アプリ説明
### コンセプト
相手と目を合わせずに相手と目を合わせて会話が出来るアプリです。\
目を合わせて会話するのが難しいと言う人でも、このアプリを使用することでアプリが代わりに目を合わせてくれるため、円滑にコミュニケーションを取ることが出来ます。\
\
<img src="https://github.com/user-attachments/assets/7cb8a212-6a10-4678-ae93-7e49e0b18eda" width="380px" style="margin: auto;" />

### 推しポイント
PWAでネイティブアプリ風になっているため、全画面表示をすることが出来、より目を合わせている感じを演出しています。\
また、専用のアタッチメントである帽子を使用することで、ハンズフリーで使用することが出来ます。

### ターゲットユーザー
目を合わせて会話することが難しい人。

### 使い方
[https://inkyame.pages.dev/](https://inkyame.pages.dev/)にアクセスしてホーム画面に追加、もしくはインストールボタンからインストールしてください。\
ホーム画面に追加されたインキャ眼を起動してください。\
起動後バックグラウンドでカメラの起動等の処理が行われるため、少し待機していると目が顔を追従するようになります。

### 動作確認環境
- OS
    - Windows 11
    - Android 13
    - iPadOS 18.2.1
    - iOS 18.3
- ブラウザー
    - Chrome
    - Microsoft Edge
    - Safari

※ 動かない場合は設定からブラウザのカメラのアクセスを許可してください。

## 開発方法
1. repositoryをcloneする:
    ```sh
    git clone https://github.com/kireitolemon/inkyame.git
    ```
2. プロジェクトディレクトリに移動する:
    ```sh
    cd inkyame
    ```
3. セットアップをする:
    ```sh
    make init
    ```
4. ローカルサーバーを起動して開発を始める:
    ```sh
    make start
    ```
5. ブラウザを開いて確認する:\
    [http://localhost:5173/](http://localhost:5173/)

## 使用技術
- 開発環境
    - Docker
- フレームワーク
    - Vue3
- 使用ライブラリ・API
    - p5.js
    - face-api.js
- アプリ仕様
    - PWA
- ホスティング
    - Cloudflare Pages
