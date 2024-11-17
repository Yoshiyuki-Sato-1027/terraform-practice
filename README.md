## tfenv の導入

```bash
# (terraformをすでにインストールしている場合に必要)terraformを無効化する
$ brew unlink terraform

# tfenvのインストール
$ brew install tfenv

# .terraform-versionのバージョンを使用する
$ terraform --version
```

## AppleSilicon の場合にローカルで terraform init ができないときの tips

```bash
# m1-terraform-provider-helperをインストール
$ brew install kreuzwerker/taps/m1-terraform-provider-helper

$ m1-terraform-provider-helper activate

# terraform initをしたときのエラー文を読み、「template」と「v2.10.0」は任意の値を記述
$ m1-terraform-provider-helper install hashicorp/template -v v2.10.0
```

## tflint の導入

```bash
# tflintのインストール
$ brew install tflint

# .tflint.hclの設定を適用する
$ tflint --init

# .terraform-versionのバージョンを使用する
$ tflint --recursive
```

## コマンド

### コード整形

```bash
$ terraform fmt --recursive
```

### 確認をスキップ

```bash
$ terraform apply -auto-approve

$ terraform destroy -auto-approve
```
