variable "SSL_domain" {
    type = string
    #サブドメイン入力
    default = ""
}

variable "Route53_zone_name" {
    type = string
    #管理しているドメイン入力
    default = ""
}