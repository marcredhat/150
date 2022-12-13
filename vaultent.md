
```
root@ip-10-10-16-196:/home/ubuntu# export VAULT_ADDR=https://ip-10-10-16-196:8200
root@ip-10-10-16-196:/home/ubuntu# vault status
Error checking seal status: Get "https://ip-10-10-16-196:8200/v1/sys/seal-status": x509: certificate signed by unknown authority
```

```
root@ip-10-10-16-196:/home/ubuntu# export VAULT_CACERT=/etc/pki/tls/
ca-key.pem      ca.pem          server-key.pem  server.pem
root@ip-10-10-16-196:/home/ubuntu# export VAULT_CACERT=/etc/pki/tls/ca.pem
root@ip-10-10-16-196:/home/ubuntu# vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.12.2+ent
Build Date         2022-11-23T21:33:30Z
Storage Type       file
HA Enabled         false
```

