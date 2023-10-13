resource "aws_key_pair" "helix" {
  key_name   = "helix"
  public_key = var.helix_pub_key
}
