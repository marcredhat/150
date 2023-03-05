```
fetch cm: kubectl get cm clientconfigs-default-kerberos-conf -n dex-app-wq5xlhrz -o yaml
the data is base64 encoded, decode it and then make the change
delete the existing cm: kubectl delete cm clientconfigs-default-kerberos-conf -n dex-app-wq5xlhrz
create the new cm using update file: kubectl create cm -n dex-app-wq5xlhrz clientconfigs-default-kerberos-conf --from-file=krb5.conf=aws-xhu/krb5.conf
```
