resource "aws_route53_zone" "test_internal_zone" {
    name = "testcsod.internal"
    
    vpc {
        vpc_id = var.vpc_id
    }
    
    tags = {
        Name = "test-internal-zone"
    }
}

resource "aws_route53_record" "test_db_record" {
    zone_id         = aws_route53_zone.test_internal_zone.zone_id
    name            = "db.testcsod.internal"
    type            = "CNAME"
    ttl             = "5"
    records         = [var.db_endpoint]
}
