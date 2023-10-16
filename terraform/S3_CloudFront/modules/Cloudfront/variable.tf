variable "URL" {
    type = string
    #ホストゾーンで登録したいサブドメイン入力
    default = ""
}

variable "ACM_arn" {
  type = string
  #ここのみCreate_ACMで出力されたACMのarnを入力してください
  default = ""
}

variable "S3_id" {
    type = string
}
variable "S3_domain_name" {
    type = string
}
