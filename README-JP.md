# iris-fhirserver-template について
FHIR サーバとして IRIS for Health Community Edition を使用するための開発テンプレートです。

開発テンプレートの中では、FHIR サーバの設定、テストデータのインポート、REST API の使用例を含む簡単な Web ページが用意されます。


## 前提条件
このテンプレートを利用するために、[git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) と [Docker desktop](https://www.docker.com/products/docker-desktop) のインストールが必要です。


## インストール方法 

clone/git pull を使用してローカルディレクトリにリポジトリをダウンロードします。

```
$ git clone https://github.com/intersystems-community/iris-fhir-template.git
```

clone したディレクトリでターミナルを開き、以下実行します。

```
$ docker-compose up -d
```

## Patient data
このテンプレートでは、[/fhirdata](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/fhirdata) フォルダに5人の患者データのサンプルを用意していて、[docker build](https://github.com/intersystems-community/iris-fhir-server-template/blob/8bd2932b34468f14530a53d3ab5125f9077696bb/iris.script#L26) のときにロードしています。

また、[synthea-loader.sh](/synthea-loader.sh) を使用して任意数の患者データを生成できます。
ターミナルを開き、git clone で生成されたディレクトリに移動し以下実行します（Windowsで実行する場合は、synthea-loader.bat をご利用ください。）。

```
#./synthea-loader.sh 5
```

上記実行により、5人の患者データ用ファイルが data/fhir 以下に追加されます。
IRIS のターミナルを開き、FHIRSERVER へ移動します。

```
docker-compose exec iris iris session iris -U FHIRServer
```

FHIRSERVER のプロンプトが表示されたら以下実行します。

```
FHIRSERVER>do ##class(fhirtemplate.Setup).LoadPatientData("/irisdev/app/data/fhir","FHIRSERVER","/fhir/r4")
```

より多くの患者データサンプルを作成されたい場合は、こちら [following project](https://github.com/intersystems-community/irisdemo-base-synthea) をご利用ください。


## FHIR R4 API のテスト方法

開発テンプレートが提供する FHIR サーバの Capability Statement をご参照ください。
以下 URL から FHIR サーバの Capability Statement を参照できます。

http://localhost:32783/fhir/r4/metadata 


## Postman を利用して Capability Statement を参照する 
FHIR リソースのメタ情報を取得するには、以下の GET要求を実行します。

GET http://localhost:32783/fhir/r4/metadata

<img width="881" alt="Screenshot 2020-08-07 at 17 42 04" src="https://user-images.githubusercontent.com/2781759/89657453-c7cdac00-d8d5-11ea-8fed-71fa8447cc45.png">


Postman で以下のGET要求を実行するとリソース ID=1 の患者リソースを取得できます。

http://localhost:32783/fhir/r4/Patient/1

<img width="884" alt="Screenshot 2020-08-07 at 17 42 26" src="https://user-images.githubusercontent.com/2781759/89657252-71606d80-d8d5-11ea-957f-041dbceffdc8.png">



## 簡単な フロントエンドアプリから FHIR API の呼び出しをテストする方法

Patient と Observation の FHIR リソースを検索し、結果を参照する非常に基本的なフロントエンドアプリは、以下 URL で参照できます。

http://localhost:32783/csp/user/fhirUI/FHIRAppDemo.html

VSCode ObjectScript メニューからも開くことができます:
<img width="616" alt="Screenshot 2020-08-07 at 17 34 49" src="https://user-images.githubusercontent.com/2781759/89657546-ea5fc500-d8d5-11ea-97ed-6fbbf84da655.png">

ページを開くと、貧血の症状を持つ女性患者の検索結果を参照できます。
また、特定の患者IDを指定すると、ヘモグロビン値のグラフを参照できます。

<img width="484" alt="Screenshot 2020-08-06 at 18 51 22" src="https://user-images.githubusercontent.com/2781759/89657718-2b57d980-d8d6-11ea-800f-d09dfb48f8bc.png">


## 参考情報
[InterSystems IRIS FHIR Documentation](https://docs.intersystems.com/irisforhealth20203/csp/docbook/Doc.View.cls?KEY=HXFHIR)

[FHIR API](http://hl7.org/fhir/resourcelist.html)

[Developer Community FHIR section（US版）](https://community.intersystems.com/tags/fhir)

[Developer Community FHIR section（日本版）](https://jp.community.intersystems.com/tags/fhir)


## コーディングの開始方法（ObjectScript）
このGitリポジトリは、ObjectScript のプラグイン使用して VSCode でコーディングする準備が整っています。
[VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) プラグインインストールします。あとは、VSCoed でリポジトリのフォルダを開くだけです。

/src/cls/PackageSample/ObjectScript.cls を開き何か変更を加えてみてください。Ctrl+Sで保存すると実行中の IRIS docker コンテナでコンパイルされます。

![docker_compose](https://user-images.githubusercontent.com/2781759/76656929-0f2e5700-6547-11ea-9cc9-486a5641c51d.gif)

PackageSample フォルダはサンプルです。ObjectScript 練習用として、編集、削除などお好みで行ってください。
もし、新規でクラスを作成する場合は /src 以下にパッケージ名のフォルダを作成し、その下にクラス名のファイル（例：Classname.cls）を配置してください。
例）　/src/Package/Classname.cls
 
ご参考：[Read more about folder setup for InterSystems ObjectScript](https://community.intersystems.com/post/simplified-objectscript-source-folder-structure-package-manager)


## リポジトリの中身について

### Dockerfile

IRIS を起動し、開発テンプレートに必要なファイルのコピー（[/src](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/src) 、[/fhirdata](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/fhirdata)、[/fhirUI](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/fhirUI) 、[/iris.script](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/iris.script) ）と iris.script の実行を行います。

関連する docker-compose.yml を使用して、ポート番号やホストフォルダをマップする場所などの追加パラメータを簡単に設定します。



### .vscode/settings.json

[VSCode ObjectScript プラグイン](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)を使って VSCode ですぐにコーディングできるようにするための設定ファイルです。

### .vscode/launch.json
VSCode ObjectScript でデバッグしたい場合の設定ファイルです。


## トラブルシューティング

### ERROR #5001: Error -28 Creating Directory /usr/irissys/mgr/FHIRSERVER/
このエラーが出る場合、docker の空き容量を使い果たしてしまった可能性があります。以下のコマンドを利用して未使用のイメージ、キャッシュ、コンテナを削除することができます。
（-f オプションを指定しない場合、確認用のプロンプトが出力されます）

```
$ docker system prune -f
```

上記コマンド実行後、キャッシュを使用しないイメージの再構築を行います。

```
$ docker-compose build --no-cache
```

上記コマンド実行後、コンテナを開始します。

```
$ docker-compose up -d
```

この他のヒントについては、[dev.md](/dev.md) をご参照ください。


