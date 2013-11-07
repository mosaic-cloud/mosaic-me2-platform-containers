#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


"${_scripts}/deploy-core"
"${_scripts}/deploy-packages"
"${_scripts}/deploy-overlays"
"${_scripts}/deploy-clean"


exit 0
