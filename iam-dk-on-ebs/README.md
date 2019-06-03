To build and test with Docker do the following:

    $ docker build -t iam-dk-img .
    ...
    $ docker run -it -p 3000:8080 --rm iam-dk-img
    ...
    ^C

Troubleshooting any issues using log files:

    $ docker run -d -p 3000:8080 --name iam-dk-www iam-dk-img
    ...
    $ docker exec -it iam-dk-www bash
    root@xxxxxxx:/var/app# tail -f -n 50 /var/log/uwsgi/*.log
    ...

To deploy, zip up just the `application.py` and `cron.yaml` files and upload to
as a new [Application Version](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/application/versions?applicationName=iam-dk-on-ebs).

### Lessons Learned with ECS and Fargate Cluster

 * Need to create the ALB before you create the app service in the cluster
 * Swap out the default TG for the one created with your app service
 * For the target group to be able to talk to the container instances, you need
   to have both 80 (public port) and 8080 (container port) allowed as inbound
   rules in the SG
 * Keep your task definition names consistent!
 