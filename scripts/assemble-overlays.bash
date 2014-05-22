#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


echo "[ii] applying overlays..." >&2

while read _prefix _type _overlay ; do
	
	case "${_type}" in
		( curl-tar-gz )
			if ! test -e "${_outputs}/rootfs/${_prefix}" ; then
				mkdir -p -m 0755 -- "${_outputs}/rootfs/${_prefix}"
			fi
		;;
		( curl-file | curl-file+* | sources-file | sources-file+* )
			if ! test -e "${_outputs}/rootfs/$( dirname -- "${_prefix}" )" ; then
				mkdir -p -m 0755 -- "${_outputs}/rootfs/$( dirname -- "${_prefix}" )"
			fi
		;;
	esac
	
	case "${_type}" in
		( curl-tar-gz )
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
		;;
		( curl-file | curl-file+* )
			env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_arguments[@]}" \
					-- "${_overlay}" \
				>"${_outputs}/rootfs/${_prefix}"
			chmod 444 -- "${_outputs}/rootfs/${_prefix}"
		;;
		( sources-file | sources-file+* )
			cp --no-preserve=all -L -T -- "${_sources}/${_overlay}" "${_outputs}/rootfs/${_prefix}"
			chmod 444 -- "${_outputs}/rootfs/${_prefix}"
		;;
		( * )
			false
		;;
	esac
	
	case "${_type}" in
		( curl-file+x | sources-file+x )
			chmod 555 -- "${_outputs}/rootfs/${_prefix}"
		;;
		( *+* )
			false
		;;
	esac
	
done < <(
	if test -e "${_sources}/overlays.txt" ; then
		"${_sed_variables[@]}" <"${_sources}/overlays.txt"
	fi
)


echo "[ii] applying symlinks..." >&2

while read _link _target ; do
	
	if ! test -e "$( dirname -- "${_outputs}/rootfs/${_link}" )" ; then
		mkdir -p -m 0755 -- "$( dirname -- "${_outputs}/rootfs/${_link}" )"
	fi
	
	ln -s -f -T -- "${_target}" "${_outputs}/rootfs/${_link}"
	
done < <(
	if test -e "${_sources}/symlinks.txt" ; then
		"${_sed_variables[@]}" <"${_sources}/symlinks.txt"
	fi
)


exit 0
