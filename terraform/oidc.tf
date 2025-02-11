resource "aws_iam_openid_connect_provider" "circleci" {
  url             = "https://oidc.circleci.com/org/42fe5219-31c4-4765-a628-c45967cef254"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["c31f72d5eb4d8d5bebd1f1ddf4baae01e0779530"]
}
