#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


while read _container ; do
	
	if test -e "${_workbench}/containers/${_container}/sources/.disabled" ; then
		continue
	fi
	
	echo "[ii] preparing \`${_container}\`..." >&2
	"${_workbench}/containers/${_container}/scripts/prepare"
	echo "[--]" >&2
	
	echo "[ii] packaging \`${_container}\`..." >&2
	"${_workbench}/containers/${_container}/scripts/package"
	echo "[--]" >&2
	
	echo "[ii] publishing \`${_container}\`..." >&2
	"${_workbench}/containers/${_container}/scripts/publish"
	echo "[--]" >&2
	
	if test "${pallur_bundle_timestamp_flush:-true}" == true ; then
		touch -- "${_workbench}/containers/${_container}/.outputs/bundle.timestamp"
	fi
	
done < <(
	find "${_workbench}/containers" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	| sort
)


exit 0
