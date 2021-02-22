#!/bin/sh

if [ "$1" = "master" ]
then
    mysql -e "SET GLOBAL read_only=OFF"
    # Generic admin user
    mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'password'"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
    # Replication user
    mysql -e "CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'password'"
    mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'"
    # Orchestrator user
    mysql -e "CREATE USER IF NOT EXISTS 'orchestrator'@'%' IDENTIFIED BY 'orch_topology_password';"
    mysql -e "GRANT SUPER, PROCESS, REPLICATION SLAVE, RELOAD ON *.* TO 'orchestrator'@'%';"
    mysql -e "GRANT SELECT ON mysql.slave_master_info TO 'orchestrator'@'%';"
    # Test database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS sakila"
    mysql -e "CREATE USER IF NOT EXISTS 'sakila'@'%' IDENTIFIED BY 'sakila'"
    mysql -e "GRANT ALL PRIVILEGES ON sakila.* TO 'sakila'@'%'"
    mysql -e "CREATE DATABASE IF NOT EXISTS world"
    mysql -e "CREATE USER IF NOT EXISTS 'world'@'%' IDENTIFIED BY 'world'"
    mysql -e "GRANT ALL PRIVILEGES ON world.* TO 'world'@'%'"
    # Monitor user for proxysql
    mysql -e "CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED BY 'monitor'"
    mysql -e "GRANT REPLICATION CLIENT ON *.* TO 'monitor'@'%'"
    # We need this otherwise, it fails when this host becomes a replica
    mysql -e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='password'"

    # Load world database
    mysql world < /sample_databases/world.sql
elif [ "$1" = "slave" ]
then
    REPLICATION_STATUS="$(mysql -e 'show slave status')"
    # Replication is not set up
    if [ -z "$REPLICATION_STATUS" ]
    then
        mysql -e "RESET MASTER"
        mysql -e "CHANGE MASTER TO MASTER_HOST='db1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_AUTO_POSITION=1; START SLAVE"
    fi
fi
