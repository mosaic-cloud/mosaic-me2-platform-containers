#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


echo "[ii] applying unmounts..." >&2

while read _mount ; do
	
	umount "${_mount}"
	
done < <(
	cut -d ' ' -f 2 /proc/mounts \
	| grep -E -e "^$( readlink -e -- "${_outputs}/rootfs" )/" || true
)


exit 0
