#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_mosaic_deploy_cp:-false}" == true ; then
	test -n "${_mosaic_deploy_cp_store}"
	_mosaic_deploy_cp_target="${_mosaic_deploy_cp_store}/${_bundle_name}--${_bundle_version}.${_bundle_revision}.mb"
	echo "[ii] deploying via \`cp\` method to \`${_mosaic_deploy_cp_target}\`..." >&2
	cp -T -- "${_outputs}/bundle.mb" "${_mosaic_deploy_cp_target}"
fi

if test "${_mosaic_deploy_me2:-false}" == true ; then
	test -n "${_mosaic_deploy_me2_credentials}"
	test -n "${_mosaic_deploy_me2_store}"
	_mosaic_deploy_me2_target="${_mosaic_deploy_me2_store}/${_me2_group//.//}/${_bundle_name}/${_bundle_name}-${_bundle_version}.${_bundle_revision}-${_me2_arch}.mb"
	echo "[ii] deploying via \`me2\` method to \`${_mosaic_deploy_me2_target}\`..." >&2
	env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_arguments[@]}" \
			--anyauth --user "${_mosaic_deploy_me2_credentials}" \
			--upload-file "${_outputs}/bundle.mb" \
			-- "${_mosaic_deploy_me2_target}"
fi

exit 0
