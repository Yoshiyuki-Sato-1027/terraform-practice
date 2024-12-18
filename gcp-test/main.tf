provider "google" {
  credentials = file("./keys/your-service-account-key.json") # サービスアカウントキーのパス
  project     = "your-project-id"                            # プロジェクトID
  region      = "us-central1"                                # 使用するリージョン
}

resource "random_id" "test" {
  byte_length = 8
}
