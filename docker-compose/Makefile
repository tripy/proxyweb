up:
	docker-compose up --remove-orphans -d
	docker-compose exec db1 /setup_topology.sh master
	docker-compose exec db2 /setup_topology.sh slave
	docker-compose exec db3 /setup_topology.sh slave
	docker-compose exec db4 /setup_topology.sh slave
	docker-compose exec orchestrator /usr/local/orchestrator/orchestrator -c discover -i db1
	docker-compose exec proxysql_donor /setup_proxysql.sh

down:
	docker-compose down --volumes
