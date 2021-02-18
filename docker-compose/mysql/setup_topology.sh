#!/bin/sh

if [ "$1" = "master" ]
then
    mysql -uroot -psecret_password -e "SET GLOBAL read_only=OFF"
    # Generic admin user
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'password'"
    mysql -uroot -psecret_password -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
    # Replication user
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'password'"
    mysql -uroot -psecret_password -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'"
    # Orchestrator user
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'orchestrator'@'%' IDENTIFIED BY 'orch_topology_password';"
    mysql -uroot -psecret_password -e "GRANT SUPER, PROCESS, REPLICATION SLAVE, RELOAD ON *.* TO 'orchestrator'@'%';"
    mysql -uroot -psecret_password -e "GRANT SELECT ON mysql.slave_master_info TO 'orchestrator'@'%';"
    # Test database and user
    mysql -uroot -psecret_password -e "CREATE DATABASE IF NOT EXISTS sakila"
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'sakila'@'%' IDENTIFIED BY 'sakila'"
    mysql -uroot -psecret_password -e "GRANT ALL PRIVILEGES ON sakila.* TO 'sakila'@'%'"
    mysql -uroot -psecret_password -e "CREATE DATABASE IF NOT EXISTS world"
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'world'@'%' IDENTIFIED BY 'world'"
    mysql -uroot -psecret_password -e "GRANT ALL PRIVILEGES ON world.* TO 'world'@'%'"
    # Sysbench database and user
    mysql -uroot -psecret_password -e "CREATE DATABASE IF NOT EXISTS sbtest"
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'sysbench'@'%' IDENTIFIED BY 'sysbench'"
    mysql -uroot -psecret_password -e "GRANT ALL PRIVILEGES ON sbtest.* TO 'sysbench'@'%'"
    # Monitor user for proxysql
    mysql -uroot -psecret_password -e "CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED BY 'monitor'"
    mysql -uroot -psecret_password -e "GRANT USAGE, REPLICATION CLIENT ON *.* TO 'monitor'@'%'"
    # We need this otherwise, it fails when this host becomes a replica
    mysql -uroot -psecret_password -e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='password'"


    # Load world database
    mysql -uroot -psecret_password world < /sample_databases/world.sql
elif [ "$1" = "slave" ]
then
    REPLICATION_STATUS="$(mysql -uroot -psecret_password -e 'show slave status')"
    # Replication is not set up
    if [ -z "$REPLICATION_STATUS" ]
    then
        mysql -uroot -psecret_password -e "RESET MASTER"
        mysql -uroot -psecret_password -e "CHANGE MASTER TO MASTER_HOST='db1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_AUTO_POSITION=1; START SLAVE"
    fi
fi
