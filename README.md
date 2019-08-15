# CouchbaseCluster

Four node couchbase cluster using enterprise version 6.0.1 with configuration scripts for creating buckets, joining nodes to cluster, and starting rebalance

### Using docker-compose to create the cluster

Download/clone the repo into a folder.

Open a bash/powershell/command prompt and navigate to the folder with the yml file.

Run 'docker-compose up -d' (without the quotes). The couchbase image will download and the installation will proceed.

If you make changes to the configuration or scripts, remember to run 'docker-compose down' first. Then run 'docker-compose up -d --build' to apply your changes.

### Connecting to the cluster

Once the cluster is up and running you can connect to each node individually using a web browser:

* Node 1: http://localhost:9191
* Node 2: http://localhost:9291
* Node 3: http://localhost:9391
* Node 4: http://localhost:9491

The configured username and password is admin/password.

### Choosing the installed services

Edit the SERVICES variable in the docker-compose.yml file putting desired services in comma separated list eg: kv,n1ql,index,fts. Valid services are:

* kv
* n1ql 
* index
* fts

where

* kv = the data service (key value data store)
* n1ql = the query service (allows you to run sql like queries)
* index = index service - pretty sure you need this to run n1ql queries
* fts = full test search service

Refer to couchbase docs for recommended distribution of different services across cluster nodes.

### Configuring buckets

Open the buckets.txt file.

Add a new line for each bucket you want created on the cluster. 
Make sure you specify the correct bucket type. Valid options are:

* couchbase
* memcached
* ephemeral

Couchbase buckets store documents on disk.
Memcached buckets store document in memory on a single node (and so are lost if node is shut down).
Ephemeral buckets are also stored in memory only, but can be replicated across nodes to provide fault tolerance.

For couchbase and ephemeral buckets you can specify the number of replicas (last column in the file). Memcached buckets cannot have replicas.

Note that the default config provided allocates 100MB per bucket, and 1000MB total for the cluster.

