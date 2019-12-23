This is a temporary branch for reading from `crawlera_samples` topic

# Secor 0.22 _(Kafka 0.10.0.1)_

This project uses Docker to produce a Docker image containing an uber-jar (single jar containing all dependencies) version of Pinterest Secor (https://github.com/pinterest/secor).

Currently, this project packages Secor 0.22, using Kafka client version 0.10.0.1.

`docker-entrypoint.sh` is the entrypoint into the image, it is responsible for taking passed in ENV vars at runtime and configuring Secor accordingly. The table below shows all ENV variables you can specify to configure Secor's operation.

## Building the Image

You can build the image locally by doing:

```shell
docker build -t [yourorg/]secor .
```

## How to Run

Example:

```shell
docker run \
  -e DEBUG=true \
  -e ZOOKEEPER_QUORUM=zookeeper.quorum.consul:2181 \
  -e SECOR_GS_BUCKET=YOUR_GS_BUCKET \
  -e SECOR_GS_PATH=YOUR_GS_PATH \
  -e SECOR_GS_CREDENTIALS_PATH=YOUR_GS_CREDENTIALS_PATH \
  -e SECOR_GROUP=raw_logs \
  secor
```

There are many more configuration options that can be passed in via `-e NAME=value`, described in the table below.

## Releasing (to Ovotech)

The Docker Hub repo ([ovotech/secor](https://hub.docker.com/r/ovotech/secor/)) is configured to automatically build when this repository is changed (i.e., when a change is pushed to `master`, or when a tag/release is created). 

## Configuration options

Can be configured using environment variables:

Environment Variable Name                    | Required? | Purpose
------------------------------------|-----------|---------------------------------------------------------------------------------------------------
`ZOOKEEPER_QUORUM`                           | **Yes**   | Zookeeper quorum (not required if `KAFKA_SEED_BROKER_HOST` is specified)
`KAFKA_SEED_BROKER_HOST`                     | **Yes**   | Kafka broker hosts (not required if `ZOOKEEPER_QUORUM` is specified)
`SECOR_GS_BUCKET`                            | **Yes**   | The GS bucket into which backups will be persisted
`SECOR_GS_PATH`                              | **Yes**   | Path within GS bucket where sequence files are stored
`SECOR_GS_CREDENTIALS_PATH`                  | **Yes**   | JSON file with Google Cloud Storage API credentials
`SECOR_FILE_READER_WRITER_FACTORY`           | **No**    | Which `WriterFactory` to use (defaults to: `SequenceFileReaderWriterFactory`)
`DEBUG`                                      | **No**    | Enable some debug logging (defaults to: `false`)
`JVM_MEMORY`                                 | **No**    | How much memory to give the JVM (via the `-Xmx` parameter) (defaults to: `512m`)
`KAFKA_SEED_BROKER_PORT`                     | **No**    | Kafka broker port (defaults to: `9092`)
`SECOR_KAFKA_TOPIC_FILTER`                   | **No**    | Regexp filter which topics it should replicate (defaults to: `.*`)
`SECOR_KAFKA_TOPIC_BLACKLIST`                | **No**    | Which topics to exclude from backing up
`SECOR_MAX_FILE_BYTES`                       | **No**    | Max bytes per file stored in S3 (defaults to: `200000000`)
`SECOR_MAX_FILE_SECONDS`                     | **No**    | Max time per file before it is stored in S3 (defaults to: `3600`)
`SECOR_COMPRESSION_CODEC`                    | **No**    | Which Hadoop compression codec to use for partition files
`SECOR_FILE_EXTENSION`                       | **No**    | Custom file extension to be appended to all partition names
`SECOR_TIMESTAMP_NAME`                       | **No**    | When using `DateMessageParser` what field to use in the JSON (defaults to: `timestamp`)
`SECOR_TIMESTAMP_PATTERN`                    | **No**    | When using `DateMessageParser` what format the timestamp is
`PARTITIONER_GRANULARITY_HOUR`               | **No**    | Should Secor partition the files up by hour as well as day? (defaults to: `false`)
`PARTITIONER_GRANULARITY_MINUTE`             | **No**    | Should Secor partition the files up by hour as well as hour, and day? (defaults to: `false`)
`SECOR_KAFKA_GROUP`                          | **No**    | Kafka consumer group name (defaults to: `secor_backup`)
`SECOR_MESSAGE_PARSER_CLASS`                 | **No**    | Which message parser factory to use (defaults to: `OffsetMessageParser`)
`SECOR_GENERATION`                           | **No**    | Generational version ID to differentiate between incompatible upgrades (defaults to: `1`)
`SECOR_CONSUMER_THREADS`                     | **No**    | Number of consumer threads per Secor process (defaults to: `7`)
`SECOR_MESSAGES_PER_SECOND`                  | **No**    | Maximum number of messages consumed per second for the **entire process** (defaults to: `10000`)
`SECOR_OFFSETS_PER_PARTITION`                | **No**    | How many offsets should be stored within a backed up partition? (defaults to: `10000000`)
`KAFKA_OFFSETS_STORAGE`                      | **No**    | Should offsets be stored in Kafka or ZooKeeper? (defaults to: `kafka`)
`KAFKA_DUAL_COMMIT_ENABLED`                  | **No**    | Should Secor commit processed offsets to Kafak AND ZooKeeper? (defaults to: `false`)
`SECOR_OSTRICH_PORT`                         | **No**    | What port should Ostrich data be sent on (defaults to: `9999`)
`KAFKA_NEW_CONSUMER_SSL_KEY_PASSWORD`        | **No**    | SSL key password
`KAFKA_NEW_CONSUMER_SSL_KEYSTORE_LOCATION`   | **No**    | SSL keystore location
`KAFKA_NEW_CONSUMER_SSL_KEYSTORE_PASSWORD`   | **No**    | SSL keystore password
`KAFKA_NEW_CONSUMER_SSL_TRUSTSTORE_LOCATION` | **No**    | SSL truststore location
`KAFKA_NEW_CONSUMER_SSL_TRUSTSTORE_PASSWORD` | **No**    | SSL truststore password
`KAFKA_NEW_CONSUMER_SECURITY_PROTOCOL`       | **No**    | SSL consumer security protocol
