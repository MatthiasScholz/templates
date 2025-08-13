# Grafana as Code

Supporting the development cycle.

## Local Grafana

```sh
grafana server --config=./grafana/default.ini --homepath ./grafana cfg:default.paths.logs=./grafana/logs cfg:default.paths.data=./grafana/data cfg:default.paths.plugins=./grafana/plugins
```
