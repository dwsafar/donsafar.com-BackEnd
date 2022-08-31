//API Gateway creation

resource "aws_api_gateway_rest_api" "lambda_gw" {
  name        = "lambda-api"
  description = "created by Don Safar"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_gw.id
  resource_id   = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
  lifecycle {
    prevent_destroy = true
  }  
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.options_method]
    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }

  depends_on = [aws_api_gateway_method.options_method]
    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,HEAD'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.options_200]
    lifecycle {
    prevent_destroy = true
  }
}
//GET

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_gw.id
  resource_id   = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_method_response" "get_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.get_method]
    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.get_method.http_method
  
  integration_http_method = "POST"
  type        = "AWS"
  uri         = aws_lambda_function.lambda_api.invoke_arn
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }

  depends_on = [aws_api_gateway_method.get_method , aws_lambda_function.lambda_api]
    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_integration_response" "get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  resource_id = aws_api_gateway_rest_api.lambda_gw.root_resource_id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.get_response.status_code
  depends_on = [aws_api_gateway_integration.get_integration]
    lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "api_donsafar" {
  certificate_arn = "${data.aws_acm_certificate.aci_issued.arn}"
  domain_name     = "api.${var.root_domain_name}"
    lifecycle {
    prevent_destroy = true
  }
 }

resource "aws_api_gateway_deployment" "gw_deploy" {
  depends_on = [aws_api_gateway_integration.get_integration]
  rest_api_id = aws_api_gateway_rest_api.lambda_gw.id
  stage_name  = "Production"
    lifecycle {
    prevent_destroy = true
  }
}
