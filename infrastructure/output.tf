output "StrongSwan_EC2_Public_IP" {
  value = aws_instance.StrongSwanVPN_webserver.public_ip
}

