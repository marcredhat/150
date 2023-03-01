
```
[rocky@full1 crip]$ crip export pem -u https://full4.base.local:7183
Successfully Exported certificates
```

```
[rocky@full1 crip]$ ls
'cn=baselocal.crt'   crip   crip.tar.gz
```

```
[rocky@full1 crip]$ cat cn\=baselocal.crt
subject=CN=*.base.local
issuer=CN=Example Intermediate CA
-----BEGIN CERTIFICATE-----
MIIDljCCAn6gAwIBAgIQCTLZrRA4gydj9GvkcFH34jANBgkqhkiG9w0BAQsFADAi
MSAwHgYDVQQDExdFeGFtcGxlIEludGVybWVkaWF0ZSBDQTAeFw0yMzAyMjQyMDAx
MzFaFw0yNTExMjAyMDAyMzFaMBcxFTATBgNVBAMMDCouYmFzZS5sb2NhbDCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANMeChVQft1mQhPrMK9Op5xAg1+J
W4nH7N+/uUcpNRuv9+YbnTVZiWlKfY2+FaTr71rJhOWuF8YDQFsps7BTB54wETO7
6+CboVXBO+Mtl2dAgHFkUEHhgTu9Yo9zi572KvBA+O/52irQQsZtO7FuBH9zcFd4
fBIi/S9vE+0nTO89/uZczUcqYN1IWnS00tl9SfXtn9CbvMuyphBSz+h7TuHcce7V
g7V4bXfMpldIQ2YZOGMK31Dh/rrCU/5ctHw5TE83C63NwSEpeNHLQbFlPaiCvaS+
7u6q7/VcP+ItaXQcJ09c7gN8dCwDQvBxVtiUiWa3WwrFz0laZWxBjVCtTTcCAwEA
AaOB0jCBzzAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG
AQUFBwMCMB0GA1UdDgQWBBRqPDc/w1Pc44HQfB4aTnFvvhmezTAfBgNVHSMEGDAW
gBTwJrsYXtMYk82cKmwILa0r7OLB9jAXBgNVHREEEDAOggwqLmJhc2UubG9jYWww
RQYMKwYBBAGCpGTGKEABBDUwMwIBAQQBbQQrRkxNbHB0QmtLaUhpNzc4Z0otRGJ5
RXdNUU9BeGw4alhWZXNMTHRpbkFUNDANBgkqhkiG9w0BAQsFAAOCAQEAWp/0Nv4C
67diiVL8eTEeiJurWq5h+TY+dkPCl910qXFl6+D1GdVNT4P2XyLVjj7QIXkvWymF
/3+dW+a6fhQshSRY2ND6hLyiKH1DhbKIwXL/h9JoXVOC1u8WNVk3cIZNgueKrDKz
rdeDCRF95nSTKPyneZDAH9NATYsHYJOFS5u7zUQcuyw0tfGyufwf6836Br9y7rhL
0ryCxynVna+2u/FC3puEJaiAqIf/+cSgS1Ce5oT3mk/4epM6x9mknI6oeVUTz5MS
umWpBQyx9HNJXpg+L+xHD7ZT0F3M2g4dTRAIywYsAYV7apoMKWidBtwufTLcvSEg
rpva7KJR5zQNWQ==
-----END CERTIFICATE-----
```

```
[rocky@full1 crip]$ crip print -u https://full4.base.local:7183
Certificates for url = https://full4.base.local:7183

[
[
  Version: V3
  Subject: CN=*.base.local
  Signature Algorithm: SHA256withRSA, OID = 1.2.840.113549.1.1.11

  Key:  Sun RSA public key, 2048 bits
  params: null
  modulus: 26651095322016363361116166398766022082769247866164193301881187578315579853420677560857121197458687027846493372678830528737787044437037334964893903434759509419713558462405401457257775572817313533148592224577149814206568677429999493112410572751987870075676366132845358561643909011528670438055891842098052581835167204943694627232278189863312066002976460052993647707526867914114334409273249515952039358029446503078698921964047903362583776488823707341623897635043384724081550453314346807864524535974841497615877805759988765299216695946385777887509417431473430937246120331836199172561850135061093807846608436716174477970743
  public exponent: 65537
  Validity: [From: Fri Feb 24 20:01:31 UTC 2023,
               To: Thu Nov 20 20:02:31 UTC 2025]
  Issuer: CN=Example Intermediate CA
  SerialNumber: [    0932d9ad 10388327 63f46be4 7051f7e2]

Certificate Extensions: 6
[1]: ObjectId: 1.3.6.1.4.1.37476.9000.64.1 Criticality=false
Extension unknown: DER encoded OCTET string =
0000: 04 35 30 33 02 01 01 04   01 6D 04 2B 46 4C 4D 6C  .503.....m.+FLMl
0010: 70 74 42 6B 4B 69 48 69   37 37 38 67 4A 2D 44 62  ptBkKiHi778gJ-Db
0020: 79 45 77 4D 51 4F 41 78   6C 38 6A 58 56 65 73 4C  yEwMQOAxl8jXVesL
0030: 4C 74 69 6E 41 54 34                               LtinAT4


[2]: ObjectId: 2.5.29.35 Criticality=false
AuthorityKeyIdentifier [
KeyIdentifier [
0000: F0 26 BB 18 5E D3 18 93   CD 9C 2A 6C 08 2D AD 2B  .&..^.....*l.-.+
0010: EC E2 C1 F6                                        ....
]
]

[3]: ObjectId: 2.5.29.37 Criticality=false
ExtendedKeyUsages [
  serverAuth
  clientAuth
]

[4]: ObjectId: 2.5.29.15 Criticality=true
KeyUsage [
  DigitalSignature
  Key_Encipherment
]

[5]: ObjectId: 2.5.29.17 Criticality=false
SubjectAlternativeName [
  DNSName: *.base.local
]

[6]: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: 6A 3C 37 3F C3 53 DC E3   81 D0 7C 1E 1A 4E 71 6F  j<7?.S.......Nqo
0010: BE 19 9E CD                                        ....
]
]

]
  Algorithm: [SHA256withRSA]
  Signature:
0000: 5A 9F F4 36 FE 02 EB B7   62 89 52 FC 79 31 1E 88  Z..6....b.R.y1..
0010: 9B AB 5A AE 61 F9 36 3E   76 43 C2 97 DD 74 A9 71  ..Z.a.6>vC...t.q
0020: 65 EB E0 F5 19 D5 4D 4F   83 F6 5F 22 D5 8E 3E D0  e.....MO.._"..>.
0030: 21 79 2F 5B 29 85 FF 7F   9D 5B E6 BA 7E 14 2C 85  !y/[)....[....,.
0040: 24 58 D8 D0 FA 84 BC A2   28 7D 43 85 B2 88 C1 72  $X......(.C....r
0050: FF 87 D2 68 5D 53 82 D6   EF 16 35 59 37 70 86 4D  ...h]S....5Y7p.M
0060: 82 E7 8A AC 32 B3 AD D7   83 09 11 7D E6 74 93 28  ....2........t.(
0070: FC A7 79 90 C0 1F D3 40   4D 8B 07 60 93 85 4B 9B  ..y....@M..`..K.
0080: BB CD 44 1C BB 2C 34 B5   F1 B2 B9 FC 1F EB CD FA  ..D..,4.........
0090: 06 BF 72 EE B8 4B D2 BC   82 C7 29 D5 9D AF B6 BB  ..r..K....).....
00A0: F1 42 DE 9B 84 25 A8 80   A8 87 FF F9 C4 A0 4B 50  .B...%........KP
00B0: 9E E6 84 F7 9A 4F F8 7A   93 3A C7 D9 A4 9C 8E A8  .....O.z.:......
00C0: 79 55 13 CF 93 12 BA 65   A9 05 0C B1 F4 73 49 5E  yU.....e.....sI^
00D0: 98 3E 2F EC 47 0F B6 53   D0 5D CC DA 0E 1D 4D 10  .>/.G..S.]....M.
00E0: 08 CB 06 2C 01 85 7B 6A   9A 0C 29 68 9D 06 DC 2E  ...,...j..)h....
00F0: 7D 32 DC BD 21 20 AE 9B   DA EC A2 51 E7 34 0D 59  .2..! .....Q.4.Y

]
```
