provider "aws" {
  access_key = "-"
  secret_key = "-"
  region = "ap-southeast-1" 
}

resource "aws_iam_role" "iam_for_lambdacloudwatch" {
  name = "iam_for_lambdacloudwatch"

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


resource "aws_lambda_function" "secheduledlambda" {
    filename = "../lambda-handler-1.0-SNAPSHOT.jar"
    function_name = "ScheduledPrintlambda"
    role ="${aws_iam_role.iam_for_lambdacloudwatch.arn}"
    handler = "com.lambda.scheduler.LambdaMethodHandler::handleSimpleRequest"
    runtime = "java8"
    timeout = "60"
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
    name = "every_five_minutes"
    description = "Triggered every 5mins"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "print_every_five_minutes" {
    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
    target_id = "secheduledlambda"
    arn = "${aws_lambda_function.secheduledlambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_scheduledlambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.secheduledlambda.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
}


