
https://full4.base.local:7183/api/v51/certs/truststorePassword


```
(OPEN-env) [rocky@full1 cloudera-playbooks]$ grep -rni full_truststore .
./cldr-runner/collections/ansible_collections/cloudera/cluster/roles/infrastructure/ca_common/defaults/main.yml:62:tls_uber_truststore_path: "{{ base_dir_security_pki }}/full_truststore.jks"
```


```
[rocky@full4 ~]$ keytool -list -keystore /opt/cloudera/security/pki/full_truststore.jks -v | grep -A 10 -B 10 "Example" | more
Enter keystore password:

*******************************************
*******************************************


Alias name: exampleintermediateca
Creation date: Feb 28, 2023
Entry type: trustedCertEntry

Owner: CN=Example Intermediate CA
Issuer: CN=Example Root CA
Serial number: bd550ccf0ae3081735766f10cdf8870a
Valid from: Fri Feb 24 19:42:41 UTC 2023 until: Mon Feb 21 19:42:41 UTC 2033
Certificate fingerprints:
	 SHA1: E7:EE:70:2F:66:68:F3:02:07:9E:D1:B2:49:61:C3:0E:4E:3A:73:F3
	 SHA256: F7:2E:7A:07:7D:C0:FB:12:69:47:3A:27:62:98:75:17:4B:02:AE:C6:8E:17:AD:15:41:76:19:EB:F0:C0:81:77
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:
--


*******************************************
*******************************************


Alias name: examplerootca
Creation date: Feb 28, 2023
Entry type: trustedCertEntry

Owner: CN=Example Root CA
Issuer: CN=Example Root CA
Serial number: b941de4f358ffad69980ea653bd18525
Valid from: Fri Feb 24 19:42:05 UTC 2023 until: Mon Feb 21 19:42:05 UTC 2033
Certificate fingerprints:
	 SHA1: 9F:56:28:FB:B7:C9:91:F7:C2:22:13:C0:CF:75:3F:26:DE:2B:D0:3D
	 SHA256: 32:34:31:DB:52:58:C3:A2:82:85:67:F0:E1:EE:14:EA:0D:BD:06:F3:B5:B3:F1:6D:32:52:66:9E:2D:EC:E8:7D
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:
--


*******************************************
*******************************************


Alias name: intermediate_ca
Creation date: Feb 28, 2023
Entry type: trustedCertEntry

Owner: CN=Example Intermediate CA
Issuer: CN=Example Root CA
Serial number: bd550ccf0ae3081735766f10cdf8870a
Valid from: Fri Feb 24 19:42:41 UTC 2023 until: Mon Feb 21 19:42:41 UTC 2033
Certificate fingerprints:
	 SHA1: E7:EE:70:2F:66:68:F3:02:07:9E:D1:B2:49:61:C3:0E:4E:3A:73:F3
	 SHA256: F7:2E:7A:07:7D:C0:FB:12:69:47:3A:27:62:98:75:17:4B:02:AE:C6:8E:17:AD:15:41:76:19:EB:F0:C0:81:77
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:
--


*******************************************
*******************************************


Alias name: root_ca
Creation date: Feb 28, 2023
Entry type: trustedCertEntry

Owner: CN=Example Root CA
Issuer: CN=Example Root CA
Serial number: b941de4f358ffad69980ea653bd18525
Valid from: Fri Feb 24 19:42:05 UTC 2023 until: Mon Feb 21 19:42:05 UTC 2033
Certificate fingerprints:
	 SHA1: 9F:56:28:FB:B7:C9:91:F7:C2:22:13:C0:CF:75:3F:26:DE:2B:D0:3D
	 SHA256: 32:34:31:DB:52:58:C3:A2:82:85:67:F0:E1:EE:14:EA:0D:BD:06:F3:B5:B3:F1:6D:32:52:66:9E:2D:EC:E8:7D
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:
```
