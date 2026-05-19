locals {

      common_tags = {

            Project= var.project
            Environment = var.environment
            Terraform = true
      }
      vpc_final_tags = {
                local.common_tags,
                {
                    Name = "${var.project}-${var.environment}"
                },
                var.vpc_tags
        }
        gw_final_tags = {
                 local.common_tags,
                 {
                    Name = "${var.project}"
                 },
                 var.gw_tags
        }
}
