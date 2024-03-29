#!/bin/bash

if [ $( psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -tAc "SELECT 1 FROM pg_namespace WHERE nspname = 'zafira'" ) == '1' ];
then
echo "Schema already exists"
exit 1
fi

psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-structure.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-data.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-views.sql
psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER -f /docker-entrypoint-initdb.d/sql/db-widgets.sql


if [ "$ZAFIRA_AMAZON_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_AMAZON_ENABLED' WHERE NAME='AMAZON_ENABLED';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_AMAZON_BUCKET' WHERE NAME='AMAZON_BUCKET';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_AMAZON_ACCESS_KEY' WHERE NAME='AMAZON_ACCESS_KEY';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_AMAZON_SECRET_KEY' WHERE NAME='AMAZON_SECRET_KEY';"
fi

if [ "$ZAFIRA_JENKINS_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_JENKINS_ENABLED' WHERE NAME='JENKINS_ENABLED';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_JENKINS_URL' WHERE NAME='JENKINS_URL';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_JENKINS_USER' WHERE NAME='JENKINS_USER';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_JENKINS_API_TOKEN_OR_PASSWORD' WHERE NAME='JENKINS_API_TOKEN_OR_PASSWORD';"
fi

if [ "$ZAFIRA_EMAIL_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_EMAIL_ENABLED' WHERE NAME='EMAIL_ENABLED';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_EMAIL_HOST' WHERE NAME='EMAIL_HOST';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_EMAIL_PORT' WHERE NAME='EMAIL_PORT';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_EMAIL_USER' WHERE NAME='EMAIL_USER';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_EMAIL_PASSWORD' WHERE NAME='EMAIL_PASSWORD';"
fi

if [ "$ZAFIRA_RABBITMQ_ENABLED" == true ];
then
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_ENABLED' WHERE NAME='RABBITMQ_ENABLED';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_HOST' WHERE NAME='RABBITMQ_HOST';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_PORT' WHERE NAME='RABBITMQ_PORT';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_USER' WHERE NAME='RABBITMQ_USER';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_PASS' WHERE NAME='RABBITMQ_PASSWORD';"
    psql --username $POSTGRES_USER -c "UPDATE zafira.SETTINGS SET VALUE='$ZAFIRA_RABBITMQ_WS' WHERE NAME='RABBITMQ_WS';"
fi
