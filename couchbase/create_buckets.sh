#!/bin/bash
 
echo "Creating buckets based on buckets.txt"

FIRSTROW=1
ROW=1

while IFS=, read -r col1 col2 col3 col4
do  
  if [ "$ROW" -ne "$FIRSTROW" ];then
	BUCKET_NAME=${col1}
	BUCKET_USER=${col2}
	BUCKET_TYPE=${col3}
	REPLICAS=${col4}

	echo "\nCreating bucket:" $BUCKET_NAME "\n"
	curl --silent --show-error -X POST -u ${USERNAME}:${PASSWORD} \
	  "http://${HOSTNAME}:8091/pools/default/buckets" \
	  -d name=$BUCKET_NAME \
	  -d bucketType=$BUCKET_TYPE \
	  -d ramQuotaMB=100 \
	  -d authType=sasl \
	  -d replicaNumber=$REPLICAS \
	  -d flushEnabled=1 \
	  -d saslPassword=$BUCKET_USER \
	  > /dev/null	  

	echo "\nCreating bucket user:" $BUCKET_USER "\n"
	curl --silent --show-error -X PUT --data "name=${BUCKET_USER}&roles=data_reader[${BUCKET_NAME}],data_writer[${BUCKET_NAME}]&password=${BUCKET_USER}" \
	  -H "Content-Type: application/x-www-form-urlencoded" \
	  "http://${USERNAME}:${PASSWORD}@${HOSTNAME}:8091/settings/rbac/users/local/${BUCKET_USER}"
  fi
  
  ROW=`expr $ROW + 1`
	
done < buckets.txt
