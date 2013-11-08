#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test -d "${_outputs}/rootfs" ; then
	find "${_outputs}/rootfs" -xdev -delete
fi


exit 0