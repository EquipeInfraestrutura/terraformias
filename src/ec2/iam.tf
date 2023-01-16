#resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = "${aws_iam_role.labdados_ec2_role.id}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("ec2-policy.json")}"
}

#resource "aws_iam_role" "labdados_ec2_role" {
  name = "labdados_ec2_role"
  assume_role_policy = "${file("ec2-assume-policy.json")}"
  path = "/"
}

#resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.labdados_ec2_role.name}"
}