#!/bin/bash

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

test "${#}" -eq 1

exec /usr/bin/env -i \
		mosaic_component_log=/tmp/log.txt \
	/opt/mosaic-components-mysql/bin/mosaic-components-mysql--run-component \
		00000000190a256e5dcaa1825e8c17117d5415ad \
		"/dev/fd/${1}"

exit 1
