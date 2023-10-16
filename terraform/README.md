## 前準備
1．enviromentディレクトリにAWSのアクセスキーおよびシークレットキーを記入するファイル(variable.tfvars)が2つあるので記入してください。またterraformのバージョンの違いで動かないことがあり得ますので注意。\
2．modulesディレクトリに「CretificateManagerとRoute53」、「CloudFront」、「S3バケット」を作成するディクトリ・ファイルがあります。それぞれvariable.tfファイルに適切な変数を代入してください。\
  基本コメントアウトの指示通りに書いてくれれば問題ないです。
以上で準備は終わりです。

## 実施手順
※今回はACMのみバージニアリージョンで作成するため、enviromentディレクトリが2つ構成になっています。そのため、terraform applyを2回する必要があります。

1．まず/terraform/S3_CloudFront/enviroment/Create_ACMディレクトリに移動し、以下のコマンド実施
```
terraform init
terraform plan
terraform apply
```
2．1を実施したらoutputでACMのarnが出てくるはずなので、値を/modules/CloudFront/variable.tfのvariable "ACM_arn"のdefaultにコピペしてください（前述の通り、ACMのみ別リージョンで作成しているためこんな面倒くさいことをしています）。
3．/terraform/S3_CloudFront/enviroment/Create_s3_CFディレクトリに移動し、以下のコマンド実施
```
terraform init
terraform plan
terraform apply
```

これで完成です。S3とCloudFrontを用いたウェブサイトホスティングができているはずです。
