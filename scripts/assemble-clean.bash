#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


echo "[ii] cleaning rootfs..." >&2

if test -d "${_outputs}/rootfs" ; then
	chmod -R +w -- "${_outputs}/rootfs"
	find "${_outputs}/rootfs" -xdev -delete
fi


exit 0
