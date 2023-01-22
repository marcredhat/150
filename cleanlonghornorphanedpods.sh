#https://github.com/longhorn/longhorn/issues/3207
while true ; do
for o in $(tail /var/log/syslog | grep -o  -E 'orphaned pod \\"((\w|-)+)\\' | cut -d" " -f3 | grep -oE '(\w|-)+' | uniq); do
	p="/var/lib/kubelet/pods/$o/volumes/*"
	if [ -d "$p" ] ; then
	  echo "Removing $o"
	  rm -rf "$p"
	fi
done
sleep 2
done
