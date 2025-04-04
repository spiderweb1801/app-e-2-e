# output "network_resources" {
#     value = {
#         vpc_id = aws_vpc.vpc.id
#         public_subnet_ids = values(aws_subnet.public_subnets)[*].id
#         private_subnet_ids = values(aws_subnet.private_subnets)[*].id
#         public_subnet_id1 = aws_subnet.public_subnets["subnet1"].id
#         public_subnet_id2 = aws_subnet.public_subnets["subnet2"].id
#         private_subnet_id1 = aws_subnet.private_subnets["subnet1"].id
#         private_subnet_id2 = aws_subnet.private_subnets["subnet2"].id
#     }
# }