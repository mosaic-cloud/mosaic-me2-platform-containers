#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"

for _folder in /dev /proc /sys /run /tmp ; do
	find "${_outputs}/rootfs/${_folder}" -xdev -mindepth 1 -delete
done

for _folder in \
		/boot /media /mnt /selinux /srv /var /home /root \
		/usr/local /usr/src /usr/include /usr/tmp \
		/usr/share/doc /usr/share/man /usr/share/info
do
	test -e "${_outputs}/rootfs/${_folder}" || test -h "${_outputs}/rootfs/${_folder}" || continue
	find "${_outputs}/rootfs/${_folder}" -xdev -delete
done

for _folder in /bin /sbin /lib /etc /usr ; do
	find "${_outputs}/rootfs/${_folder}" -xdev -mindepth 1 -type d -empty -delete
done

for _folder in /dev /proc /sys ; do
	chmod 0000 -- "${_outputs}/rootfs/${_folder}"
done

exit 0
