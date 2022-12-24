# ----------------
# RDS parameter group
# ----------------

resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  # ブロック型なのでイコールは不要
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

}

# ----------------
# RDS option group
# ----------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ----------------
# RDS subnet group
# ----------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------
# RDS instance
# ----------------

# パスワード用ランダム文字列 
resource "random_string" "db_password" {
  length  = 16
  special = false # 特殊文字はなし
}

# resource "aws_db_instance" "mysql_standalone" {
#   engine         = "mysql"
#   engine_version = "8.0.28"

#   identifier = "${var.project}-${var.environment}-mysql-standalone"

#   username = "admin"
#   password = random_string.db_password.result # 上記で生成した文字列

#   instance_class = "db.t2.micro"

#   allocated_storage     = 20    # 容量20G
#   max_allocated_storage = 50    #最大50Gまで可能
#   storage_type          = "gp2" # デフォルトのストレージタイプ
#   storage_encrypted     = false # 暗号化は行わない

#   multi_az             = false
#   availability_zone    = "ap-northeast-1a" # マルチAZを使用しないので、指定する必要がある
#   db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnetgroup.name
#   vpc_security_group_ids = [
#     aws_security_group.db_sg.id
#   ]

#   publicly_accessible = false
#   port                = 3306

#   name                 = "tastylog"
#   parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
#   option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

#   #メンテナンスの前にバックアップを行うこと！（前後が逆になると、メンテナンスに失敗したときに復旧できない！）
#   backup_window              = "04:00-05:00" #バックアップの時間帯
#   backup_retention_period    = 7             #一週間分バックアップを保管
#   maintenance_window         = "Mon:05:00-Mon:08:00"
#   auto_minor_version_upgrade = false #自動でマイナーバージョンを更新するか（更新する場合、上記のメンテナンス時間帯で実行する）

#   # 削除防止設定
#   deletion_protection = false
#   skip_final_snapshot = true

#   apply_immediately = true

#   tags = {
#     Name    = "${var.project}-${var.environment}-mysql-standalone"
#     Project = var.project
#     Env     = var.environment
#   }
# }
