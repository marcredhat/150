

 cat /opt/cloudera/CMCA/CMCA/private/.ca_key_password
  
 cat > tmp.py  << EOF
import hashlib
from subprocess import Popen, PIPE, STDOUT
def hex_str(byteArr):
 return ''.join(format(ord(x), '02x') for x in byteArr)
obfuscated_password ='e298a3f09f92a3e298a0 1 Zglpbged7QHSzeJnPveIjclBk7l7nR1uAqOXXNoPpZ2 //k2XHb3l26V5eSYWbeWdBIC0nqWmaR1fUOOn6tJNTPRxyVoHQPjAycEYA=='
hdr, version, random, enc = obfuscated_password.split()
OBFUSCATION_SECRET="f09f998ff09f93bff09fa49e"
OBFUSCATION_HEADER="e298a3f09f92a3e298a0"
m=hashlib.sha512()
m.update(random)
m.update(OBFUSCATION_SECRET)
m2 = m.copy()
m.update("IV")
iv = m.digest()[:16] # 128 bits for IV
m2.update("KEY")
key = m2.digest()[:32] # 256 bits for key
p = Popen(["openssl", "enc", "-d", "-aes-256-ofb",
 "-K", hex_str(key),
 "-iv", hex_str(iv),
 "-a", "-A",
 ],
 stdin=PIPE, stdout=PIPE, stderr=PIPE)
stdout, stderr = p.communicate(enc)
print (stdout)
EOF
 
export host=ml-efd2c24e-d13.apps.apps.airgap-l1-4-10.kcloud.cloudera.com

openssl req -new -newkey rsa:3072 -nodes -keyout ${host}.key -subj "/CN=${host}/OU=PS/O=Cloudera, Inc./ST=CA/C=US" -out ${host}.csr
openssl req -in ${host}.csr -text -verify



echo "[default]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.${host}
DNS.2 = ${host}" > cml.ext

openssl x509 -req -extfile cml.ext -days 365 -in ${host}.csr -CA /var/lib/cloudera-scm-agent/agent-cert/cm-auto-in_cluster_ca_cert.pem -CAkey /opt/cloudera/CMCA/CMCA/private/ca_key.pem -CAcreateserial -out ${host}.crt -passin pass:$(python tmp.py)
openssl x509 -in ${host}.crt -text -noout


export host=ml-efd2c24e-d13.apps.apps.airgap-l1-4-10.kcloud.cloudera.com
kubectl delete secret/cml-tls-secret -n devcml
kubectl create secret tls cml-tls-secret --cert=${host}.crt --key=${host}.key -o yaml --dry-run | kubectl -n devcml create -f -

