provider "aws" {
    access_key = "-"
    secret_key = "-"
    region = "ap-southeast-1" 
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "javalambda" {
    filename = "../lambda-handler-1.0-SNAPSHOT.zip"
    function_name = "JavaPrintlambda"
    role ="${aws_iam_role.iam_for_lambda.arn}"
    handler = "com.lambda.scheduler.LambdaMethodHandler::handleRequest"
    runtime = "java8"
    timeout = "60"
}
