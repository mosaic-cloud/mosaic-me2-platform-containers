#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"

for _path in "${_outputs}/rootfs.cpio" "${_outputs}/spec.json" "${_outputs}/MANIFEST.mf" "${_outputs}/bundle.zip" ; do
	if test -e "${_path}" ; then
		rm -- "${_path}"
	fi
done


(
	cd -- "${_outputs}/rootfs"
	exec find . -xdev -print0
) | \
(
	cd -- "${_outputs}/rootfs"
	exec cpio \
		--create \
		--format newc \
		--null \
) \
>|"${_outputs}/rootfs.cpio"


cat >|"${_outputs}/spec.json" <<EOS
...
EOS


cat >|"${_outputs}/MANIFEST.mf" <<EOS
...
EOS


zip \
		-1 --junk-paths \
	"${_outputs}/bundle.zip" -- \
		"${_outputs}/MANIFEST.mf" \
		"${_outputs}/spec.json" \
		"${_outputs}/rootfs.cpio"

exit 0
