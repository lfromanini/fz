#!/usr/bin/env bash

export PATH_BIN="${BATS_TEST_DIRNAME}"/../bin/
export PATH_MOCKS_DIR="${BATS_TEST_DIRNAME}"/../tests/mocks/
export PATH_MOCKS="${PATH_MOCKS_DIR}:${PATH}"

export FZF_MOCK_OUTPUT=""

# shellcheck disable=SC2329     # SC2329: This function is never invoked. Check usage (or ignored if invoked indirectly).
function mockFzfEscape()
{
	function fzf()
	{
		if [[ "${1}" == "--bash" ]] ; then
			"${PATH_MOCKS_DIR}"/fzf --bash
			return $?
		fi

		cat > /dev/null         # consume stdin to prevent SIGPIPE
		return 130
	}

	export -f fzf
}
