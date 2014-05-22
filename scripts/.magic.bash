#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


while read _container ; do
	
	echo "[ii] preparing \`${_container}\`..." >&2
	"${_workbench}/containers/${_container}/scripts/prepare"
	echo "[--]" >&2
	
	echo "[ii] packaging \`${_container}\`..." >&2
	"${_workbench}/containers/${_container}/scripts/package"
	echo "[--]" >&2
	
	echo "[ii] deploying \`${_container}\`..." >&2
	if test "${pallur_deploy_skip:-true}" != true ; then
		"${_workbench}/containers/${_container}/scripts/deploy"
	else
		echo "[ww]   -- skipped!" >&2
	fi
	echo "[--]" >&2
	
	if test "${pallur_bundle_timestamp_flush:-true}" == true ; then
		touch -- "${_workbench}/containers/${_container}/.outputs/bundle.timestamp"
	fi
	
done < <(
	find "${_workbench}/containers" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n'
)


exit 0
