
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

https://developer.hashicorp.com/vault/tutorials/enterprise/namespaces#create-namespaces

```
root@ip-10-10-16-196:/home/ubuntu# vault operator init
Unseal Key 1: mWMwm+4tKzBB6O4m0nOfoh5RZ4IeibwyIbWx/9CCZamz
Unseal Key 2: PbAfIsrYHTqWlHNgH5CygeeW8f7/t1kleWBGaU3zFgUn
Unseal Key 3: 5BQWFnMBnk69VlgQnzLTObDYyE/+jN9KyKQIz1uDQM1x
Unseal Key 4: UzGfPnjE6ozQwsNeTOjxpJr0XiTbv9wuSDJ6u61OtAGm
Unseal Key 5: Yg3NPT+I8e5+rWaT2Y4vo18eK434uSV5oMP8xcam2Ltg

Initial Root Token: hvs.zUuX014x3YAQX1AlXySwtqGo

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

```
vault operator unseal
```

```
vault login
```

```
root@ip-10-10-16-196:/home/ubuntu# vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                hvs.zUuX014x3YAQX1AlXySwtqGo
token_accessor       YVXyRsavFhZefuFXYf54sRKe
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
root@ip-10-10-16-196:/home/ubuntu# vault namespace create education
Key                Value
---                -----
custom_metadata    map[]
id                 Otzxt
path               education/
```

```
vault policy write --namespace education  vaultpolicy ./vaultpolicy
```

```
root@ip-10-10-16-196:/home/ubuntu# vault token create -policy=vaultpolicy
Key                  Value
---                  -----
token                hvs.CAESIKPpl_wjXM8FFCU79q8bplyyd1_W0D3xSa5-I-dUVva7Gh4KHGh2cy5VUXIzVllWMTBTVUlXOTFKQzd5UWRxaUc
token_accessor       DfTJQ0CsnBJCkDEIgGXL47W3
token_duration       768h
token_renewable      true
token_policies       ["default" "vaultpolicy"]
identity_policies    []
policies             ["default" "vaultpolicy"]
```
