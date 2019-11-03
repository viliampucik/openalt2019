output "ip" {
  value       = aws_instance.web.public_ip
  description = "Web server public IP"
}

output "ami" {
  value       = data.aws_ami.ami.id
  description = "Web server AMI"
}

output "ssh" {
  value       = "ssh -i id_rsa ec2-user@${aws_instance.web.public_ip}"
  description = "Web server SSH connection string"
}