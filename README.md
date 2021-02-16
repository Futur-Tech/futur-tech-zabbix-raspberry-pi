Original Git: https://gitlab.com/Qrl/zabbix

## Zabbix Templates

- Raspberry Pi CPU: [zbx_template_rpi.xml](https://gitlab.com/Qrl/zabbix/blob/master/zbx_template_rpi.xml)

---

### Raspberry Pi CPU Template

Items:
- CPU clock
- CPU voltage
- CPU temperature (Celsius)
- CPU throttling

CPU items interval: 1m

Triggers:
- CPU temperature is high(<70C)
- CPU is throttling

Installation:
1. Copy userparameter_rpi.conf to `/etc/zabbix/zabbix_agentd.d/` on rpi
3. Add zabbix user to video group on rpi `$ sudo usermod -a -G video zabbix`
4. Restart the zabbix agent on rpi `$ sudo service zabbix-agent restart`
5. Import zbx_template_rpi.xml to templates in Zabbix Server