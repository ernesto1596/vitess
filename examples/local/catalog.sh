source ./env.sh

# start topo server
if [ "${TOPO}" = "zk2" ]; then
	CELL=zone2 ./scripts/zk-up.sh
elif [ "${TOPO}" = "k8s" ]; then
	CELL=zone2 ./scripts/k3s-up.sh
else
	CELL=zone2 ./scripts/etcd-up.sh
fi

# start vtctld
CELL=zone2 ./scripts/vtctld-up.sh


# start vttablets for keyspace catalog
for i in 100 101 102; do
	CELL=zone2 TABLET_UID=$i ./scripts/mysqlctl-up.sh
	CELL=zone2 KEYSPACE=catalog TABLET_UID=$i ./scripts/vttablet-up.sh
done

vtctldclient InitShardPrimary --force catalog/0 zone2-100

# create the schema for commerce
vtctlclient ApplySchema -- --sql-file ./create_catalog_schema.sql catalog
vtctlclient ApplyVSchema -- --vschema_file ./vschema_catalog.json catalog