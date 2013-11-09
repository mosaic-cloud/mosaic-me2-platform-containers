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

_me2b_group=ro.ieat.mosaic.bundles
_me2b_arch=x86
_linux_arch=i686
_zypper_arch=i586

_PATH_EXTRA="${PATH_EXTRA:-}"
_PATH_CLEAN="/opt/bin:/usr/local/bin:/usr/bin:/bin"
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
		--gpg-auto-import-keys
		--verbose
)
_zypper_addrepo_arguments=(
		"${_zypper_arguments[@]}"
		addrepo
			--no-keep-packages
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
		--progress-bar
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


_distribution_version="${mosaic_distribution_version:-0.7.0}"
_bundle_name="$( basename -- "$( readlink -e -- . )" )"
_bundle_name="${_bundle_name//-/_}"
_bundle_timestamp="$( date -u '+%s' )"
_bundle_version="${mosaic_bundle_version:-${_distribution_version}.${_bundle_timestamp}}"
