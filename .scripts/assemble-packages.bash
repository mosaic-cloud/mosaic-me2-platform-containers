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
	sed -r \
			-e 's#@\{distribution_version\}@#'"${_distribution_version}"'#g' \
			-e 's#@\{bundle_version\}@#'"${_bundle_version}"'#g' \
			-e 's#@\{bundle_timestamp\}@#'"${_bundle_timestamp}"'#g' \
		<"${_sources}/packages.txt"
)


exit 0
