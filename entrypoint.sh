#!/bin/sh

# Wait until Postgres is ready
echo "$DB_USER:$DB_PASSWORD"
while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start with user $DB_USER:$DB_PASSWORD in $DB_HOST"
  sleep 2
done

./prod/rel/coinsaver/bin/coinsaver eval Coinsaver.Release.migrate


./prod/rel/coinsaver/bin/coinsaver start
