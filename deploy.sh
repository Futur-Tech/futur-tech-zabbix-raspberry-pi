#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

APP_NAME="futur-tech-zabbix-raspberry-pi"
REQUIRED_PKG_ARR=( "at" "agnostics" )

ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agentd.conf.d"
SRC_DIR="/usr/local/src/${APP_NAME}"
SUDOERS_ETC="/etc/sudoers.d/${APP_NAME}"

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

echo
echo "------------------------------------------"
echo "  INSTALL NEEDED PACKAGES & FILES"
echo "------------------------------------------"
echo

$S_DIR_PATH/ft-util/ft_util_pkg -u -i ${REQUIRED_PKG_ARR[@]} || exit 1

if [ ! -d "${ZBX_CONF_AGENT_D}" ] ; then mkdir "${ZBX_CONF_AGENT_D}" ; $S_LOG -s $? -d $S_NAME "Creating ${ZBX_CONF_AGENT_D} returned EXIT_CODE=$?" ; fi

$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/etc.zabbix/${APP_NAME}.conf" "${ZBX_CONF_AGENT_D}/${APP_NAME}.conf"

echo
echo "------------------------------------------"
echo "  SETUP SUDOERS FILE"
echo "------------------------------------------"
echo

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==== SUDOERS CONFIGURATION ===="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo "Defaults:zabbix !requiretty" | sudo EDITOR='tee' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:${SRC_DIR}/deploy-update.sh" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null

cat $SUDOERS_ETC | $S_LOG -d "$S_NAME" -d "$SUDOERS_ETC" -i 

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo
echo "------------------------------------------"
echo "  SETUP ZABBIX USER"
echo "------------------------------------------"
echo

usermod -a -G video zabbix ; $S_LOG -s $? -d $S_NAME "Adding zabbix user to video group returned EXIT_CODE=$?"

echo
echo "------------------------------------------"
echo "  RESTART ZABBIX LATER"
echo "------------------------------------------"
echo

echo "service zabbix-agent restart" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"

exit