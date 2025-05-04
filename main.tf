module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = local.security_group_name
  description = "Security group to allow open SSH and HTTP Port"
  vpc_id      = local.vpc_id

  ingress_rules            = ["ssh-tcp", "http-8080-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = []

  egress_rules            = ["all-all"]
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_with_cidr_blocks = []

}

resource "aws_key_pair" "nequi_techlead_challenge" {
  key_name   = local.keypair_name
  public_key = file("./.ssh/key-nequi-techlead-challenge.pub")
}

module "ec2" {

  providers = {
    aws = aws.main
  }

  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.ec2_instance_name

  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.nequi_techlead_challenge.key_name
  monitoring             = false
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = local.subnet_id
  user_data              = file("./.scripts/user_data.sh")

  tags = local.resource_tags

  depends_on = [module.security_group, aws_key_pair.nequi_techlead_challenge]
}