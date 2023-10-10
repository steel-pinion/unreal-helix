resource "aws_iam_role" "ec2_jump" {
  name               = "ec2-jump"
  assume_role_policy = file("./policy/assume_role_ec2_jump.json")
}

resource "aws_iam_policy" "ec2_jump" {
  name        = "ec2-jump"
  description = "give jump ec2 basic rights for debugging and ssh"
  policy      = file("./policy/ec2_jump.json")
}

resource "aws_iam_role_policy_attachment" "ec2_jump" {
  role       = aws_iam_role.ec2_jump.name
  policy_arn = aws_iam_policy.ec2_jump.arn
}

resource "aws_iam_instance_profile" "ec2_jump" {
  name = aws_iam_role.ec2_jump.name
  role = aws_iam_role.ec2_jump.name
}
