# Overview

Demonstrates an issue prefetch and delivery-limit in certain versions of
RabbitMQ.

Affected versions: 3.8.4 through 3.10.25
Fixed in: 3.11.0

# Usage

To run the reproduction on RabbitMQ 3.8.4, run `docker compose up --force-recreate`

To run the reproduction on some other version, run
`RABBITMQ_VERSION=3.10.25 docker compose up --force-recreate`

# Observing the issue
Once all 5 containers are running, visit http://localhost:15672 and log in
with the username `guest` and password `guest`. Then, inspect the queue named
`example.queue` in the default vhost.

While there are only ever 3 consumers, all of which have a prefetch value of 1,
you can observe that on affected versions of RabbitMQ the number of unacknowledged
messages for the queue grows without bound.

The number by which unacknowledged message count exceeds the sum of the prefetch
values of the consumers seems to tend to exactly equal the number of messages
that have been sent to the dead letter queue by the `delivery-limit` configuration,
although that aspect of the issue has not been verified rigorously.
