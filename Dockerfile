FROM java:9 AS build-env

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --allow-unauthenticated \
		ca-certificates curl wget apt-transport-https libsnappy-dev libssl-dev libbz2-dev python-dev python-pip \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-9-openjdk-amd64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/hadoop/lib/native
ENV PATH $PATH:/usr/local/hadoop/bin

ENV JAVA_CONF_DIR=$JAVA_HOME/conf
RUN bash -c '([[ ! -d $JAVA_SECURITY_DIR ]] && ln -s $JAVA_HOME/lib $JAVA_HOME/conf) || (echo "Found java conf dir, package has been fixed, remove this hack"; exit -1)'

ADD . /app

RUN cd /app \
	&& mkdir -p /opt/secor \
	&& cp /app/build/libs/docker-secor-all.jar /opt/secor/secor.jar \
	&& rm -rf /app

# Copy script to run Secor
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Copy out properties files
COPY *.properties /opt/secor/

ENTRYPOINT ["/docker-entrypoint.sh"]

# used for temp-files that are uploaded
VOLUME /tmp
