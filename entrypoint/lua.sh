#!/bin/bash

# load default values
. /opt/entrypoint/defaults.sh

# load some functions
. /opt/entrypoint/utils.sh

# copy stub LUA scripts
cp -r /opt/lua/* /usr/local/lib/lua

# DNS resolvers
resolvers=$(spaces_to_lua "$DNS_RESOLVERS")
replace_in_file "/usr/local/lib/lua/dns.lua" "%DNS_RESOLVERS%" "$resolvers"

# whitelist IP
list=$(spaces_to_lua "$WHITELIST_IP_LIST")
replace_in_file "/usr/local/lib/lua/whitelist.lua" "%WHITELIST_IP_LIST%" "$list"

# whitelist rDNS
list=$(spaces_to_lua "$WHITELIST_REVERSE_LIST")
replace_in_file "/usr/local/lib/lua/whitelist.lua" "%WHITELIST_REVERSE_LIST%" "$list"

# blacklist IP
list=$(spaces_to_lua "$BLACKLIST_IP_LIST")
replace_in_file "/usr/local/lib/lua/blacklist.lua" "%BLACKLIST_IP_LIST%" "$list"

# blacklist rDNS
list=$(spaces_to_lua "$BLACKLIST_REVERSE_LIST")
replace_in_file "/usr/local/lib/lua/blacklist.lua" "%BLACKLIST_REVERSE_LIST%" "$list"

# DNSBL
list=$(spaces_to_lua "$DNSBL_LIST")
replace_in_file "/usr/local/lib/lua/dnsbl.lua" "%DNSBL_LIST%" "$list"

# bad behavior
list=$(spaces_to_lua "$BAD_BEHAVIOR_STATUS_CODES")
replace_in_file "/usr/local/lib/lua/behavior.lua" "%STATUS_CODES%" "$list"
replace_in_file "/usr/local/lib/lua/behavior.lua" "%THRESHOLD%" "$BAD_BEHAVIOR_THRESHOLD"
replace_in_file "/usr/local/lib/lua/behavior.lua" "%BAN_TIME%" "$BAD_BEHAVIOR_BAN_TIME"
replace_in_file "/usr/local/lib/lua/behavior.lua" "%COUNT_TIME%" "$BAD_BEHAVIOR_COUNT_TIME"

# CrowdSec setup
if [ "$(has_value USE_CROWDSEC yes)" != "" ] ; then
	replace_in_file "/usr/local/lib/lua/crowdsec/crowdsec.conf" "%CROWDSEC_HOST%" "$CROWDSEC_HOST"
	replace_in_file "/usr/local/lib/lua/crowdsec/crowdsec.conf" "%CROWDSEC_KEY%" "$CROWDSEC_KEY"
fi
