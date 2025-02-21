
output "public_ip" {
  value = aws_instance.example.public_ip
}

output "private_key_path" {
  value = local_file.private_key.filename
}
