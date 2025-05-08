module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = local.security_group_name
  description = "Security group to allow open SSH and HTTP Port"
  vpc_id      = local.vpc_id

  ingress_rules            = ["ssh-tcp", "http-8080-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow MySQL access"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

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

resource "aws_db_subnet_group" "nequi_subnet_group" {
  name       = "nequi-techlead-challenge-subnet-group"
  subnet_ids = [
    "subnet-0e016bf7fe6a285a1",  # AZ 1
    "subnet-0022fa68419e64b6a"   # AZ 2
  ]

  tags = {
    Name = "Nequi Techlead DB Subnet Group"
  }
}

resource "aws_db_instance" "nequi_mysql_instance" {
  identifier              = "nequi-techlead-challenge-mysql-instance"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "nequi_techlead_challenge_db"
  username                = "admin"
  password                = var.db_password
  port                    = 3306
  publicly_accessible     = true
  vpc_security_group_ids  = [module.security_group.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.nequi_subnet_group.name
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false
  backup_retention_period = 0

  tags = local.resource_tags
}