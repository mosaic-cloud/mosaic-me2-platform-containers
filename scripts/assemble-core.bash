#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test ! -e "${_outputs}/rootfs"
mkdir -m 0755 -- "${_outputs}/rootfs"


echo "[ii] installing core repositories..." >&2

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://download.opensuse.org/update/${_zypper_release}" opensuse--updates--oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://download.opensuse.org/distribution/${_zypper_release}/repo/oss" opensuse--packages--oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://download.opensuse.org/update/${_zypper_release}-non-oss" opensuse--updates--non-oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://download.opensuse.org/distribution/${_zypper_release}/repo/non-oss" opensuse--packages--non-oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://ftp.info.uvt.ro/mos/opensuse/${_zypper_release}/packages" custom--packages--a

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		"http://jenkins.ieat.ro/repos/development" custom--packages--b

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_refresh_arguments[@]}"


echo "[ii] installing core packages..." >&2

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_install_arguments[@]}" \
		pattern:base."${_zypper_arch}"


echo "[ii] configuring core packages..." >&2
cat >|"${_outputs}/rootfs/etc/resolv.conf" <<EOS
search internal
nameserver 8.8.8.8
EOS


exit 0
