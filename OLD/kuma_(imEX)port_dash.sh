#!/bin/bash
# RU_PRESALE_TEAM_BORIS_O
# ver. 0.1 (15.12.2022)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

M_EXPORT=/opt/kaspersky/kuma/mongodb/bin/mongoexport
M_IMPORT=/opt/kaspersky/kuma/mongodb/bin/mongoimport
usage="\n$(basename "$0") [-h] [-export] [-import] [-delete] <ARGUMENTS> -- program for executing script\n
\n
where:\n
    ${YELLOW}-h${NC} -- show this help text\n
    ${YELLOW}-export \"<Dashboard Name>\" </path/File Export Name.json>${NC} -- export dashboard to file in JSON (dashboard name must be UNIQUE! and use \" if spaces are in the name)\n
    ${YELLOW}-import <File Export Name.json>${NC} -- import dashboard to KUMA\n
    ${YELLOW}-delete \"<Dashboard Name>\"${NC} -- delete dashboard from KUMA (dashboard name must be UNIQUE! and use \" if spaces are in the name)\n
\n
	Type: ${YELLOW}journalctl | grep KUMA-DASHBOARD-ACTIVITY${NC} -- for looking script activity in log
\n
"

if [[ $# -eq 0 ]]; then
	echo -e "${RED}No arguments supplied${NC}"
	echo -e $usage
	exit 1
fi

if [[ ! -f $M_EXPORT ]] || [[ ! -f $M_IMPORT ]]; then
    echo -e "${RED}NO mongo import or export binary files in /opt/kaspersky/kuma/mongodb/bin/${NC}"
	echo -e $usage
	exit 1
fi

case $1 in
	"-h")
	echo -e $usage
	;;

    "-export")
	if [[ ! $# -eq 3 ]] || [[ $2 == ""  ]] || [[ $3 == ""  ]]; then
		echo -e "${YELLOW}Please enter valid arguments!\nExample: -export \"My Dashboad\" MyDashboard.json${NC}"
	else
        cd /opt/kaspersky/kuma/mongodb/bin
        ./mongoexport  --db=kuma --collection=dashboards --query='{"name": "'$2'"}' | jq -c '._id="UUID" | .widgets[].tenantIDs=["T_ID"] | .tenantIDs=["T_ID"] | .widgets[].search.clusterID="C_ID" | del(.results)'> $3
		echo -e "${GREEN}Dashboard ${2} exported to file $3!${NC}"
	fi
    ;;

    "-import")
	if [[ ! $# -eq 2 ]] || [[ $2 == ""  ]] || [[ ! -f $2 ]]; then
		echo -e "${YELLOW}Please enter valid arguments!\nExample: -import /path/MyDashboard.json${NC}"
        echo -e "${YELLOW}OR Please check file $2, is it exist?${NC}"
	else
        cd /opt/kaspersky/kuma/mongodb/bin
        sed -i "s/T_ID/$(/opt/kaspersky/kuma/mongodb/bin/mongo localhost/kuma --eval 'db.dashboards.findOne({"name": "Network Overview"}).tenantIDs' | tail -1 |  awk '{print $2}' | cut -d '"' -f 2)/g" $2
        sed -i "s/C_ID/$(/opt/kaspersky/kuma/mongodb/bin/mongo localhost/kuma --eval 'db.dashboards.findOne({"name": "Network Overview"}).widgets[1].search.clusterID'  | tail -1)/g" $2
        sed -i "s/UUID/$(uuidgen)/g" $2
        ./mongoimport  --db kuma --collection dashboards --file $2
		echo -e "${GREEN}Dashboard from file ${2} imported!${NC}"
	fi
    ;;

    "-delete")
	if [[ ! $# -eq 2 ]] || [[ $2 == ""  ]]; then
		echo -e "${YELLOW}Please enter valid arguments!\nExample: -delete \"My Dashboad\"${NC}"
	else
        /opt/kaspersky/kuma/mongodb/bin/mongo kuma --eval 'db.dashboards.remove({"name": "'$2'"})'
		echo -e "${GREEN}Dashboard ${2} deleted!${NC}"
	fi
    ;;

	* )
	echo -e $usage
	;;
esac