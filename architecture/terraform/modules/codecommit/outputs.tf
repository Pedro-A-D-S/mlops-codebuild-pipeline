output "repository_clone_url_http" {
    value = aws_codecommit_repository.my_repo.repository_clone_url_http
}

output "repository_clone_url_ssh" {
    value = aws_codecommit_repository.my_repo.clone_url_ssh
}