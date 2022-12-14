```
curl -s https://admin:admin@mchisinevski-3.mchisinevski.root.hwx.site:9999/v2/_catalog
```


```
# cat .config/containers/registries.conf
[[registry]]
location="sonatype-docker-pull.infra-artifact.svc"
insecure=true

[[registry]]
location="registry.infra-artifact.svc"
insecure=true
command:

for image in $(curl -s http://sonatype-docker-pull.infra-artifact.svc/v2/_catalog | jq .repositories[] | tr -d '"'); do
  skopeo sync \
    --debug \
    --authfile auth.json \
    --src docker \
    --src-tls-verify=false \
    --dest docker \
    --dest-tls-verify=false \
    sonatype-docker-pull.infra-artifact.svc/$image \
    registry.infra-artifact.svc
done
```
