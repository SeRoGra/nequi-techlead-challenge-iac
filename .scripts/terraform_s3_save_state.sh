aws s3api create-bucket --bucket s3-nequi-techlead-challenge-terraform --region us-east-1

aws dynamodb create-table \
  --table-name dynamo-nequi-techlead-challenge-terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1