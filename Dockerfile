# Build secor from sources
FROM maven:3-jdk-8 AS build

WORKDIR /build

RUN git clone --branch v0.27 --depth 1 --single-branch https://github.com/pinterest/secor.git .

RUN mvn -Pkafka-2.0.0 package

# Build the container image using a clean java:9 base
FROM java:9

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

# Copy script to run Secor
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Copy out properties files
COPY *.properties /opt/secor/

# Copy Secor and dependencies JAR files
COPY --from=build /build/target/secor-*.jar /opt/secor/
COPY --from=build /build/target/lib /opt/secor/lib

ENTRYPOINT ["/docker-entrypoint.sh"]

# used for temp-files that are uploaded
VOLUME /tmp
