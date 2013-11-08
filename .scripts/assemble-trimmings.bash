#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


while read _method _path ; do
	
	case "${_method}" in
		( delete-children )
			find "${_outputs}/rootfs/${_path}" -xdev -mindepth 1 -delete
		;;
		( delete-recursive )
			find "${_outputs}/rootfs/${_path}" -xdev -delete
		;;
		( delete-empty-folders )
			find "${_outputs}/rootfs/${_path}" -xdev -mindepth 1 -type d -empty -delete
		;;
		( chmod-0000 )
			chmod 0000 -- "${_outputs}/rootfs/${_path}"
		;;
		( * )
			echo "[ee] invalid method \`${_method}\`" >&2
			exit 1
		;;
	esac
	
done <"${_sources}/trimmings.txt"


exit 0
