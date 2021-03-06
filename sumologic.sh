#!/bin/bash -xev

################################
# USAGE:
#
# ./sumologic.sh system access_id access_key
#
# ./sumologic.sh proxy af893rjnfiuadf fc90u3eiorjqjfnasu8v89
################################

##################################################
# Script Argument Set
##################################################

SYSTEM=${1}
ACCESS_ID=${2}
ACCESS_KEY=${3}


##################################################
# Get and Install Collector
##################################################

wget -q -O /tmp/collector.deb https://collectors.sumologic.com/rest/download/deb/64 || error_exit "Failed to get Sumologic Collector"
dpkg -i /tmp/collector.deb || error_exit "Failed to Install Sumologic Collector"
rm -f /tmp/collector.deb || error_exit "Failed to remove Sumologic Collector"

##################################################
# Set User Properties
##################################################

mkdir -p /opt/SumoCollector/config

cat > '/opt/SumoCollector/config/user.properties' << EOF
name=${HOSTNAME}
accessid=${ACCESS_ID}
accesskey=${ACCESS_KEY}
sources=/opt/SumoCollector/sources.json
ephemeral=true
EOF

##################################################
# Set Collector Sources
##################################################
if [ ${SYSTEM} == 'chef' ]; then
cat > '/opt/SumoCollector/sources.json' << EOF
{
  "api.version": "v1",
  "sources": [
    {
      "name": "Messages",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/System",
      "pathExpression": "/var/log/messages"
    },
    {
      "name": "Mail",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/System",
      "pathExpression": "/var/log/mail.log"
    },
    {
      "name": "Secure",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/Security",
      "pathExpression": "/var/log/secure"
    },
    {
      "name": "Syslog File",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/System",
      "pathExpression": "/var/log/syslog"
    },
    {
      "name": "chef_erchef",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/erchef",
      "pathExpression": "/var/log/opscode/opscode-erchef/current"
    },
    {
      "name": "chef_nginx",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/nginx",
      "pathExpression": "/var/log/opscode/nginx/*.log"
    },
    {
      "name": "chef_bookshelf",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/bookshelf",
      "pathExpression": "/var/log/opscode/bookshelf/current"
    },
    {
      "name": "chef_redis_lb",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/redis_lb",
      "pathExpression": "/var/log/opscode/redis_lb/current"
    },
    {
      "name": "chef_oc_id",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/oc_id",
      "pathExpression": "/var/log/opscode/oc_id/current"
    },
    {
      "name": "chef_oc_bifrost",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/oc_bifrost",
      "pathExpression": "/var/log/opscode/oc_bifrost/current"
    },
    {
      "name": "chef_backup",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/backup",
      "pathExpression": "/var/log/chef_backup.log"
    },
    {
      "name": "chef_manage_redis",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef-manage/redis",
      "pathExpression": "/var/log/chef-manage/redis/current"
    },
    {
      "name": "chef_manage_web",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef-manage/web",
      "pathExpression": "/var/log/chef-manage/web/current"
    },
    {
      "name": "chef_manage_worker",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef-manage/worker",
      "pathExpression": "/var/log/chef-manage/worker/current"
    },
    {
      "name": "newrelic_logs",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/new_relic",
      "pathExpression": "/var/log/newrelic/*.log"
    }
  ]
}
EOF
fi

if [ ${SYSTEM} == 'proxy' ]; then
cat > '/opt/SumoCollector/sources.json' << EOF
{
  "api.version": "v1",
  "sources": [
    {
      "name": "Messages",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/System",
      "pathExpression": "/var/log/messages"
    },
    {
      "name": "Secure",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/Security",
      "pathExpression": "/var/log/secure"
    },
    {
      "name": "Syslog File",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "OS/Linux/System",
      "pathExpression": "/var/log/syslog"
    },
    {
      "name": "NGINX_Chef_ES",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "ES_Proxy/NGINX_Logs",
      "pathExpression": "/var/log/nginx/*.log"
    },
    {
      "name": "newrelic_logs",
      "sourceType": "LocalFile",
      "automaticDateParsing": true,
      "multilineProcessingEnabled": false,
      "useAutolineMatching": true,
      "forceTimeZone": false,
      "timeZone": "UTC",
      "category": "chef/new_relic",
      "pathExpression": "/var/log/newrelic/*.log"
    }
  ]
}
EOF
fi

##################################################
# Reload and Start Collector
##################################################

systemctl --system daemon-reload && systemctl restart collector.service || error_exit "Failed to start Sumo Collector Service"
