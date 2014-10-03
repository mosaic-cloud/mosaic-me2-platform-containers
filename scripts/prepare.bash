#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


## chunk::3c8b019c663118b00172b22aeae97568::begin ##
if test ! -e "${_temporary}" ; then
	mkdir -- "${_temporary}"
fi
if test ! -e "${_outputs}" ; then
	mkdir -- "${_outputs}"
fi
## chunk::3c8b019c663118b00172b22aeae97568::end ##


if test ! -e "${_HOME}" ; then
	mkdir -- "${_HOME}"
fi
if test ! -e "${_TMPDIR}" ; then
	mkdir -- "${_TMPDIR}"
fi


touch -d "$( date -u -d "@${_bundle_timestamp}" )" -- "${_outputs}/bundle.timestamp"


exit 0
