#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


echo "[ii] cleaning old artifacts..." >&2
for _path in \
			"${_outputs}/rootfs.cpio" "${_outputs}/rootfs.tar" \
			"${_outputs}/bundle/rootfs" "${_outputs}/bundle/spec.json" "${_outputs}/bundle/MANIFEST.mf" \
			"${_outputs}/bundle.mb" "${_outputs}/bundle"
do
	if test -d "${_path}" ; then
		rmdir -- "${_path}"
	elif test -e "${_path}" ; then
		rm -- "${_path}"
	fi
done


echo "[ii] creating rootfs CPIO archive..." >&2
(
	cd -- "${_outputs}/rootfs"
	exec find . -xdev -depth -print0
) | \
(
	cd -- "${_outputs}/rootfs"
	exec env -i "${_generic_env[@]}" "${_cpio_bin}" \
		--create \
		--format newc \
		--null \
		--quiet
) \
>|"${_outputs}/rootfs.cpio"

echo "[ii] creating rootfs TAR archive..." >&2
(
	cd -- "${_outputs}/rootfs"
	exec find . -xdev -depth -print0
) | \
(
	cd -- "${_outputs}/rootfs"
	exec env -i "${_generic_env[@]}" "${_tar_bin}" \
		--create \
		--format gnu \
		--numeric-owner \
		--null --files-from /dev/stdin \
		--no-recursion
) \
>|"${_outputs}/rootfs.tar"


echo "[ii] creating bundle..." >&2

mkdir "${_outputs}/bundle"

cat >|"${_outputs}/bundle/spec.json" <<EOS
{
	"spec-version": "0.1",
	"bundle": {
		"classifier": "${_me2b_arch}",
		"group-id": "${_me2b_group}",
		"package-id": "${_bundle_name//-/_}",
		"type": "container-bundle",
		"version": "${_bundle_version}"
	},
	"configuration": {
		"entrypoints": {
			"container-bundle.init": "$( cat -- "${_sources}/entrypoint.txt" )"
		},
		"environment": {}
	}
}
EOS

ln -T -- "${_outputs}/rootfs.tar" "${_outputs}/bundle/rootfs"

cat >|"${_outputs}/bundle/MANIFEST.mf" <<EOS
EOS

####
#env -i "${_generic_env[@]}" "${_zip_bin}" \
#		--compression-method deflate -6 \
#		--junk-paths \
#	"${_outputs}/bundle.mb" -- \
#		"${_outputs}/bundle/MANIFEST.mf" \
#		"${_outputs}/bundle/spec.json" \
#		"${_outputs}/bundle/rootfs"
####

####
env -i "${_python2_env[@]}" "${_python2_bin}" "${_python2_arguments[@]}" /dev/fd/3 "${_outputs}/bundle.mb" "${_outputs}/bundle" 3<<'EOS'
import os
import sys
import zipfile
if len(sys.argv) != 3:
    print >>sys.stderr, "Invalid number of arguments"
    print >>sys.stderr, "We accept only: %s <destination_file> <source_directory>" % sys.argv[0]
    sys.exit(1)
destfile = sys.argv[1]
srcdir = sys.argv[2]
if not os.path.exists(srcdir):
    print >>sys.stderr, "Source directory does not exist"
with zipfile.ZipFile(destfile, 'w', allowZip64 = True, compression = zipfile.ZIP_DEFLATED) as bundle:
    bundle.comment = "manually made mosaic bundle"
    for dirpath, dirnames, filenames in os.walk(srcdir):
        arc_dir = os.path.relpath(os.path.abspath(dirpath), srcdir)
        for dir_file in filenames:
            effective_path = os.path.join(dirpath, dir_file)
            arc_path = os.path.join(arc_dir, dir_file)
            bundle.write(effective_path, arc_path)
sys.exit(0)
EOS
####


exit 0
