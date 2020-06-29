# Quick Start

This fork is to create a derivation of [big-data-europe/docker-spark](https://github.com/big-data-europe/docker-spark) with some python issues resolved for easy use for python based data scientists

- removed python2 version errors
- added support for gcc,make used by many packages

System requirements  : Docker , Docker compose , Spark

### Start your cluster

first build the images

```bash
$ git clone https://github.com/TheForeverLost/docker-spark.git
$ cd docker-spark
$ ./build.sh
$ docker-compose up
```

After this starts , you can get your UI console [here](http://localhost:8080) 

### Submit application

<table>
    <tr>
        <td>Spark master URL</td>
        <td>spark://localhost:7077</td>
    </tr>
</table>

so you can submit your code with 

```bash
$ spark-submit --master spark://localhost:7077 \
	--py-files <zip_filename>.zip \
	<sparkjob>.py
```

more configuration can be added using spart-submit options

to generate **<zip_filename>.zip**

```bash
$ pip install --target ./package -r requirements.txt || \
    pip install --system --target ./package -r requirements.txt
$ cp -r SamsRelevancy/ ./package
$ cp .config.json ./package
$ cd package
$ zip -r9 ../SamsRelevancy.zip ./
$ cd ../
$ rm -rf ./package
```

Note : pip here is an alias to pip3. Running this in a conda environment can give errors in building numpy

## Adding to Docker Compose

Add the following services to your `docker-compose.yml` to integrate a Spark master and Spark worker
```yml
spark-master:
  image: bde2020/spark-master:2.4.5-hadoop2.7
  container_name: spark-master
  ports:
    - "8080:8080"
    - "7077:7077"
  environment:
    - INIT_DAEMON_STEP=setup_spark
    - "constraint:node==<yourmasternode>"
spark-worker-1:
  image: bde2020/spark-worker:2.4.5-hadoop2.7
  container_name: spark-worker-1
  depends_on:
    - spark-master
  ports:
    - "8081:8081"
  environment:
    - "SPARK_MASTER=spark://spark-master:7077"
    - "constraint:node==<yourworkernode>"
spark-worker-2:
  image: bde2020/spark-worker:2.4.5-hadoop2.7
  container_name: spark-worker-2
  depends_on:
    - spark-master
  ports:
    - "8081:8081"
  environment:
    - "SPARK_MASTER=spark://spark-master:7077"
    - "constraint:node==<yourworkernode>"  
```
Make sure to fill in the `INIT_DAEMON_STEP` as configured in your pipeline.


