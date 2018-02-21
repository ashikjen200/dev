# A CloudWatch alarm that moniors CPU utilization of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "alpha_service_cpu_high" {
  alarm_name = "$service-cpu-utilization-above-80"
  alarm_description = "This alarm monitors service CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_appautoscaling_policy.scale_up.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster2.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "alpha_service_cpu_low" {
  alarm_name = "service-cpu-utilization-below-5"
  alarm_description = "This alarm monitors service CPU utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_appautoscaling_policy.scale_down.arn}"]

  dimensions {
      ClusterName = "${aws_ecs_cluster.cluster2.name}"
      ServiceName = "${aws_ecs_service.service.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "alpha_service_memory_high" {
  alarm_name = "service-memory-utilization-above-80"
  alarm_description = "This alarm monitors service memory utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_appautoscaling_policy.scale_up.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster2.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "alpha_service_memory_low" {
  alarm_name = "$service-memory-utilization-below-5"
  alarm_description = "This alarm monitors service memory utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_appautoscaling_policy.scale_down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster2.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }
}

resource "aws_appautoscaling_target" "target" {
  resource_id = "service/${aws_ecs_cluster.cluster2.name}/${aws_ecs_service.service.name}"
  role_arn = "arn:aws:iam::364833262723:role/ecsAutoscaleRole"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = "${var.min_capacity}"
  max_capacity = "${var.max_capacity}"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name = "service-scale-up"
  resource_id = "service/${aws_ecs_cluster.cluster2.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = 1
  }
  service_namespace  = "ecs"
  depends_on = ["aws_appautoscaling_target.target"]
}

resource "aws_appautoscaling_policy" "scale_down" {
  name = "service-scale-down"
  resource_id = "service/${aws_ecs_cluster.cluster2.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"

  step_adjustment  {
    metric_interval_upper_bound = 0
    scaling_adjustment = -1
  }
  service_namespace  = "ecs"
  depends_on = ["aws_appautoscaling_target.target"]
}
