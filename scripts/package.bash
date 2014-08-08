#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


"${_scripts}/assemble"
"${_scripts}/bundle"


if test -n "${_artifacts_cache}" ; then
	cp -T -- "${_outputs}/bundle.mb" "${_artifacts_cache}/${_bundle_name}--${_bundle_version}.mb"
fi


echo "[ii] packaged \`"${_me2_group}:${_bundle_name}:${_bundle_version}.${_bundle_revision}:${_me2_arch}"\`;" >&2


exit 0
