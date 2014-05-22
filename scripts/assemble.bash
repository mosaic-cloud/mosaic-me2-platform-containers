#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


"${_scripts}/assemble-clean"
"${_scripts}/assemble-core"
"${_scripts}/assemble-packages"
"${_scripts}/assemble-unmounts"
"${_scripts}/assemble-overlays"
"${_scripts}/assemble-trimmings"


exit 0
