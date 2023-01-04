#Create SAN cerets for vault.ip-10-10-16-196 using 
#https://github.com/marcredhat/150/blob/main/createcert.sh

#Copy the SAN certs to /etc/pki/tls (location specified in /etc/vault.d/vault.hcl below)
#cp create-registry-certs/* /etc/pki/tls

#root@ip-10-10-16-196:/home/ubuntu# cat /etc/vault.d/vault.hcl
# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
#disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

#storage "consul" {
#  address = "10.10.16.196:8500"
#  path    = "vault"
#}

# HTTP listener
#listener "tcp" {
#  address = "10.10.16.196:8200"
#  tls_disable = 1
#}

# HTTPS listener
listener "tcp" {
  address       = "10.10.16.196:8200"
  tls_cert_file = "/etc/pki/tls/server.pem"
  tls_key_file  = "/etc/pki/tls/server-key.pem"
  tls_client_ca_file = "/etc/pki/tls/ca.pem"
}

# Enterprise license_path
# This will be required for enterprise as of v1.8
license_path = "/etc/vault.d/vault.hclic"

# Example AWS KMS auto unseal
#seal "awskms" {
#  region = "us-east-1"
#  kms_key_id = "REPLACE-ME"
#}

# Example HSM auto unseal
#seal "pkcs11" {
#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
#  slot           = "0"
#  pin            = "AAAA-BBBB-CCCC-DDDD"
#  key_label      = "vault-hsm-key"
#  hmac_key_label = "vault-hsm-hmac-key"
#}
