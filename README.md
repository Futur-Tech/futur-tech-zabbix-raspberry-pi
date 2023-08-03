Original Git: https://gitlab.com/Qrl/zabbix

### Raspberry Pi Template

Items:
- CPU clock
- CPU voltage
- CPU temperature (Celsius)
- CPU throttling
- SD Card R/W test (with package "agnostics")

SD Card test is done once a week on Sunday at 4AM in order to avoid wear.

Triggers:
- CPU temperature is high(<70C)
- CPU is throttling

Works for Zabbix 6.0 Active Agent

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone https://github.com/Futur-Tech/futur-tech-zabbix-raspberry-pi.git
cd futur-tech-zabbix-raspberry-pi

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```

Finally import the template YAML in Zabbix Server and attach it to your host.
