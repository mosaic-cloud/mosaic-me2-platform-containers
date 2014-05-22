#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV


_workbench="$( readlink -e -- . )"
_repositories="${_workbench}/repositories"
_sources="${_workbench}/sources"
_scripts="${_workbench}/scripts"
_outputs="${_workbench}/.outputs"
_tools="${_workbench}/.tools"
_temporary="/tmp"

_me2_group=ro.ieat.mosaic.bundles
_me2_arch=x86_64
_linux_arch=x86_64
_zypper_arch=x86_64
_zypper_release=13.1

_PATH_EXTRA="${PATH_EXTRA:-}"
_PATH_CLEAN="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
_PATH="$( echo "${_tools}/bin:${_PATH_EXTRA}:${_PATH_CLEAN}" | tr -s ':' )"


_zypper_bin="$( PATH="${_PATH}" type -P -- zypper || true )"
if test -z "${_zypper_bin}" ; then
	echo "[ww] missing \`zypper\` (Zipper) executable in path: \`${_PATH}\`; ignoring!" >&2
	_zypper_bin=zypper
fi

_python2_bin="$( PATH="${_PATH}" type -P -- python2 || true )"
if test -z "${_python2_bin}" ; then
	echo "[ww] missing \`python2\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_python2_bin=python2
fi

_curl_bin="$( PATH="${_PATH}" type -P -- curl || true )"
if test -z "${_curl_bin}" ; then
	echo "[ww] missing \`curl\` (cURL) executable in path: \`${_PATH}\`; ignoring!" >&2
	_curl_bin=curl
fi

_cpio_bin="$( PATH="${_PATH}" type -P -- cpio || true )"
if test -z "${_cpio_bin}" ; then
	echo "[ww] missing \`cpio\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_cpio_bin=cpio
fi

_tar_bin="$( PATH="${_PATH}" type -P -- tar || true )"
if test -z "${_tar_bin}" ; then
	echo "[ww] missing \`tar\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_tar_bin=tar
fi

_zip_bin="$( PATH="${_PATH}" type -P -- zip || true )"
if test -z "${_zip_bin}" ; then
	echo "[ww] missing \`zip\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_zip_bin=zip
fi


_generic_env=(
		PATH="${_PATH}"
		HOME="${HOME:-${_tools}/home}"
		TMPDIR="${_temporary}"
)

_zypper_arguments=(
		--config /dev/null
		--root "${_outputs}/rootfs"
		--non-interactive
		--no-refresh
		--no-gpg-checks
		--gpg-auto-import-keys
		# --verbose
		--quiet
)
_zypper_addrepo_arguments=(
		"${_zypper_arguments[@]}"
		addrepo
			--no-keep-packages
)
_zypper_refresh_arguments=(
		"${_zypper_arguments[@]}"
		refresh
)
_zypper_install_arguments=(
		"${_zypper_arguments[@]}"
		install
			--no-recommends
			--no-force-resolution
			--auto-agree-with-licenses
			--download-as-needed
)
_zypper_env=(
		"${_generic_env[@]}"
)

_curl_arguments=(
		# --progress-bar
		--silent
)
_curl_env=(
		"${_generic_env[@]}"
)

_python2_arguments=(
		-B -E
)
_python2_env=(
		"${_generic_env[@]}"
)


if test -e "${_outputs}/bundle.timestamp" ; then
	_bundle_timestamp="$( date -u -r "${_outputs}/bundle.timestamp" '+%s' )"
else
	_bundle_timestamp="$( date -u '+%s' )"
fi

_distribution_version="${pallur_distribution_version:-0.7.0_dev}"
_bundle_name="$( basename -- "$( readlink -e -- . )" )"
_bundle_name="${_bundle_name//-/_}"
_bundle_version="${pallur_bundle_version:-${_distribution_version}}"
_bundle_revision="${pallur_bundle_revision:-${_bundle_timestamp}}"


_sed_variables=(
	sed -r
			-e 's#@\{distribution_version\}#'"${_distribution_version}"'#g'
			-e 's#@\{bundle_name\}#'"${_bundle_name}"'#g'
			-e 's#@\{bundle_version\}#'"${_bundle_version}"'#g'
			-e 's#@\{bundle_revision\}#'"${_bundle_revision}"'#g'
			-e 's#@\{bundle_timestamp\}#'"${_bundle_timestamp}"'#g'
			-e 's#@\{me2_group\}#'"${_me2_group}"'#g'
			-e 's#@\{me2_arch\}#'"${_me2_arch}"'#g'
)
