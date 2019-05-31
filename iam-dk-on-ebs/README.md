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
