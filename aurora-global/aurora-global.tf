resource "aws_db_subnet_group" "sub-group" {
  name       = lower(join("", [var.DeploymentName, "-SubGrp"]))
  subnet_ids = [var.PRIV-PRI-SUBNETSID[0].id, var.PRIV-PRI-SUBNETSID[1].id]
  tags = {
    Name = "somename"
  }
}


resource "aws_rds_global_cluster" "glcl" {
  global_cluster_identifier = lower(join("", [var.DeploymentName, "-GlobalDB"]))
  engine                    = "aurora-postgresql"
  engine_version            = "12.7"
  database_name             = "example_db"
}


resource "aws_rds_cluster" "primary" {
  depends_on                = [aws_db_subnet_group.sub-group]
  engine                    = aws_rds_global_cluster.glcl.engine
  engine_version            = aws_rds_global_cluster.glcl.engine_version
  cluster_identifier        = lower(join("", [var.DeploymentName, "-Cluster"]))
  master_username           = "username"
  master_password           = "somepass123"
  database_name             = "example_db"
  skip_final_snapshot       = true
  global_cluster_identifier = aws_rds_global_cluster.glcl.id
  db_subnet_group_name      = aws_db_subnet_group.sub-group.name
}


resource "aws_rds_cluster_instance" "nodes" {
  count                = 2
  engine               = aws_rds_global_cluster.glcl.engine
  engine_version       = aws_rds_global_cluster.glcl.engine_version
  identifier           = lower(join("", [var.DeploymentName, "-node", count.index]))
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = "db.r5.large"
  db_subnet_group_name = aws_db_subnet_group.sub-group.name
}


output "CLUSTERENGINE" {
  value = aws_rds_global_cluster.glcl.engine
}


output "CLUSTERENGINEVERSION" {
  value = aws_rds_global_cluster.glcl.engine_version
}


output "GLOBALCLUSTERID" {
  value = aws_rds_global_cluster.glcl.id
}
