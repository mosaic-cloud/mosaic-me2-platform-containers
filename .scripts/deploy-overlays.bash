#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


while read _prefix _overlay ; do
	
	if ! test -e "${_outputs}/rootfs/${_prefix}" ; then
		mkdir -p -m 0755 -- "${_outputs}/rootfs/${_prefix}"
	fi
	
	env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_arguments[@]}" \
			-- "${_overlay}" \
	| env -i "${_generic_env[@]}" "${_tar_bin}" \
			--extract \
			--gunzip \
			--overwrite \
			--no-overwrite-dir \
			--preserve-permissions \
			--owner=0 --group=0 \
			--directory="${_outputs}/rootfs/${_prefix}"
	
done <"${_workbench}/sources/overlays.txt"


exit 0
