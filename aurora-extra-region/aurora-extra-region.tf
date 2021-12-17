resource "aws_db_subnet_group" "sub-group" {
  name       = lower(join("", [var.DeploymentName, "-SubGrp"]))
  subnet_ids = [var.PRIV-PRI-SUBNETSID[0].id, var.PRIV-PRI-SUBNETSID[1].id]
  tags = {
    Name = "somename"
  }
}


resource "aws_rds_cluster" "secondary" {
  depends_on                = [aws_db_subnet_group.sub-group]
  engine                    = var.CLUSTERENGINE
  engine_version            = var.CLUSTERENGINEVERSION
  cluster_identifier        = lower(join("", [var.DeploymentName, "-Cluster"]))
  global_cluster_identifier = var.GLOBALCLUSTERID
  skip_final_snapshot       = true
  final_snapshot_identifier = "DELETE-ME"
  db_subnet_group_name      = aws_db_subnet_group.sub-group.name
}


resource "aws_rds_cluster_instance" "nodes" {
  count                = 2
  engine               = var.CLUSTERENGINE
  engine_version       = var.CLUSTERENGINEVERSION
  identifier           = lower(join("", [var.DeploymentName, "-node", count.index]))
  cluster_identifier   = aws_rds_cluster.secondary.id
  instance_class       = "db.r5.large"
  db_subnet_group_name = aws_db_subnet_group.sub-group.name
}
