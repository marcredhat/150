```
# install sonatype nexus
mkdir -pv /opt/efsfilesystem/sonatype-work
ln -sv /opt/efsfilesystem/sonatype-work /opt/sonatype-work
wget --output-document /tmp/nexus.tar.gz https://download.sonatype.com/nexus/3/nexus-3.43.0-01-unix.tar.gz 
mkdir -p /opt/nexus
tar xf /tmp/nexus.tar.gz -C /opt/nexus --strip-components 1

# run as nexus user
useradd --home-dir /opt/nexus --no-create-home --uid 1001 nexus
chown -R nexus:nexus /opt/efsfilesystem
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work
```
