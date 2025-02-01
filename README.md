# インキャ眼

## 開発方法
1. repositoryをCloneする:
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
4. docker-compose.yml内のコメントアウトを無くす:
    ```yml
    # command: npm run dev -- --host
    command: npm run dev -- --host
    ```
5. ローカルサーバーを起動して開発を始める:
    ```sh
    make start
    ```
6. ブラウザを開いて確認する:\
    [http://localhost:5173/](http://localhost:5173/)

## アプリ説明（後で書く）
### コンセプト

### 推しポイント

### ターゲットユーザー

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

