# 外からリソースを取り込む場合のもの(applyしてもAWS上は変更が起きないが、tfstateが更新される)

data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3" # リージョンはワイルドカード指定
}

data "aws_ami" "app" {
  most_recent = true               # 最新のものを取得する
  owners      = ["self", "amazon"] # 自分が登録したものと、Amazon公式のもの

  filter {
    name = "name"
    # 日付部分をワイルドカード指定することで複数ヒットさせる
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
