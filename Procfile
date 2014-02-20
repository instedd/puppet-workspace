puppet-master: puppet master --confdir . --no-daemonize --verbose
kicker: kicker -s -e "kill -HUP \`cat var/run/master.pid\`" manifests/ modules/ site-modules/
