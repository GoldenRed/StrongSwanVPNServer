aws ec2 create-key-pair --key-name SS_EC2_key --query 'KeyMaterial' --output text > SS_EC2_key.pem
chmod 400 SS_EC2_key.pem
