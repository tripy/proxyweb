#!/bin/sh

apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt/lists/*
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('sakila','sakila',1);"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('world','world',1);"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_servers (hostgroup_id,hostname) VALUES (1, 'db1')"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_servers (hostgroup_id,hostname) VALUES (1, 'db2')"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_servers (hostgroup_id,hostname) VALUES (1, 'db3')"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_servers (hostgroup_id,hostname) VALUES (1, 'db4')"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_replication_hostgroups (writer_hostgroup,reader_hostgroup,comment) VALUES (1,2,'cluster1');"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_query_rules (rule_id,active, match_digest,destination_hostgroup,apply) VALUES (1,1,'^SELECT.*FOR UPDATE',1,1)"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "INSERT INTO mysql_query_rules (rule_id,active, match_digest,destination_hostgroup,apply) VALUES (2,1,'^SELECT',2,1)"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "LOAD MYSQL SERVERS TO RUNTIME"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "LOAD MYSQL USERS TO RUNTIME"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "LOAD MYSQL QUERY RULES TO RUNTIME"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "SAVE MYSQL SERVERS TO DISK"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "SAVE MYSQL USERS TO DISK"
mysql -uradmin -pradmin -h127.0.0.1 -P6032 -e "SAVE MYSQL QUERY RULES TO DISK"
