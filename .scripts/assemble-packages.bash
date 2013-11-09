#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


while read _package ; do
	
	setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_install_arguments[@]}" \
			"${_package}"
	
done < <(
	if test -e "${_sources}/packages.txt" ; then
		"${_sed_variables[@]}" <"${_sources}/packages.txt"
	fi
)


exit 0
