data "aws_iam_policy_document" "WebServerEC2InstancePolicyDocument" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "WebServerEC2InstanceRole" {
  name               = "WebServerEC2InstanceRole"
  assume_role_policy = data.aws_iam_policy_document.WebServerEC2InstancePolicyDocument.json
}

resource "aws_iam_role_policy_attachment" "WebServerEC2InstanceRolePolicyAttachment" {
  role       = aws_iam_role.WebServerEC2InstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "WebServerEC2InstanceProfile" {
  name = "WebServerEC2InstanceProfile"
  role = aws_iam_role.WebServerEC2InstanceRole.name
}
