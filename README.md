# Материалы к докладу

# Helm

Создать чарт
```shell
helm create myservice
```
Выкатка в кластер
```shell
helm upgrade --install demo ./helm-chart -n default
```
## Ссылки

https://helm.sh


# Helm starter 

Plugin - https://github.com/salesforce/helm-starter

Стартеры - 

```shell
helm create NAME --starter /path/to/catalog/helm-starter-chart/standard
```

# Helmfile

Helmfile - https://github.com/helmfile/helmfile

Документация - https://helmfile.readthedocs.io

Best practices - https://github.com/roboll/helmfile/blob/master/docs/writing-helmfile.md