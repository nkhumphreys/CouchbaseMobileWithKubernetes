#!/bin/bash

kubectl delete services couchbase couchbase-lb
#we leave the sync-gateway service running so it's IP does not change
kubectl delete statefulset,rc,pod -l name=couchbase &>/dev/null

printf "Waiting for sync-gateway to stop"
while true ; do 
	if kubectl describe pod -l role=gateway &>/dev/null ; then
		printf "."
		sleep 2
	else
		printf "\n"
		break
	fi
done

printf "Waiting for couchbase nodes to stop"
while true ; do 
	if kubectl describe pods -l=database &>/dev/null ; then
		printf "."
		sleep 2
	else
		printf "\n"
		break
	fi
done

 
