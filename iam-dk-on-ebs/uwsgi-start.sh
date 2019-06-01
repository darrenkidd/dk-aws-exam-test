#!/bin/bash

cd /var/app

. bin/activate

# Django support
if cat requirements.txt | grep -q -i Django && [ -z "$WSGI_PATH" ]; then
	WSGI_PATH=`find /var/app | egrep '/var/app/[^/]+/wsgi.py'`
fi

# Flask support
if cat requirements.txt | grep -q -i Flask && [ -z "$WSGI_MODULE" ]; then
	WSGI_MODULE=application:app
fi

[ -n "$WSGI_MODULE" ] && UWSGI_MODULE="--module $WSGI_MODULE"

# defaulting to application.py if not explicitly set
[ -z "$WSGI_PATH" ] && WSGI_PATH=application.py

# Testing: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_cloudwatch_logs.html#configure_cwl_agent
cat /etc/awslogs/awslogs.conf
#[ec2-user ~]$ sudo mv /etc/awslogs/awslogs.conf /etc/awslogs/awslogs.conf.bak

curl -s http://localhost:51678/v1/metadata | python -m jq -r ". | .Cluster"
#[ec2-user ~]$ sudo sed -i -e "s/{cluster}/$cluster/g" /etc/awslogs/awslogs.conf

curl -s http://localhost:51678/v1/metadata | python -m jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $2}'
#[ec2-user ~]$ sudo sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf

uwsgi --http :8080 --chdir /var/app --wsgi-file $WSGI_PATH $UWSGI_MODULE --master --processes $UWSGI_NUM_PROCESSES --threads $UWSGI_NUM_THREADS --uid $UWSGI_UID --gid $UWSGI_GID --logto2 $UWSGI_LOG_FILE
