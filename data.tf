# 外からリソースを取り込む場合のもの(applyしてもAWS上は変更が起きないが、tfstateが更新される)

data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3" # リージョンはワイルドカード指定
}
