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

### ID からリソース名の逆引き

```
terraform state list -id=<id>
```

## キャッチアップ

### ポリシードキュメント

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeRegions"],
      "Resource": ["*"]
    }
  ]
}

```

- Effect: Allow or Deny
- Action: サービス : どんな操作ができるか
- Resource: 操作可能なリソース

※aws_iam_policy_document でもポリシーを記述できる

### IAM ポリシー

ポリシードキュメントを保持するリソース

### IAM ロール

AWS のサービスへ権限を付与する

「信頼ポリシー」 なんのサービスに関連付けるかの宣言のこと

### IAM ポリシーと IAM ロールをアタッチする

## ネットワーク

### パブリックネットワーク

インターネットからアクセス可能
パブリック IP アドレスを持つ

### パブリックサブネット

パブリックネットワークを分割したサブネット
VPC は、隔離されたネットワークなので単体ではインターネットと接続できない
`インターネットゲートウェイ`と`ルートテーブル`を作成する

### プライベートネットワーク

インターネットから隔離
DB サーバーなど

### マルチ AZ

### ファイアウォール

#### セキュリティグループ

インバウンドとは外部から EC2 インスタンスへ向かう内向きの通信、アウトバウンドとは EC2 インスタンスから外部へ出る外向きの通信
