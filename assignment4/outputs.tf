output "s3_bucket_names" {
  description = "Names of the created S3 buckets"
  value       = aws_s3_bucket.app_data[*].bucket
}

output "ebs_volume_id" {
  description = "ID of the extra EBS volume"
  value       = aws_ebs_volume.extra_data.id
}

# useful for verification
output "s3_bucket_arns" {
  value = aws_s3_bucket.app_data[*].arn
}

output "volume_availability_zone" {
  description = "Should match the instance's AZ"
  value       = aws_ebs_volume.extra_data.availability_zone
}

output "attached_instance_id" {
  value = data.aws_instance.web.id
}