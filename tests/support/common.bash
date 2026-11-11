#!/usr/bin/env bash

export FZ_BIN="${BATS_TEST_DIRNAME}/../bin/fz"

export PATH_MOCKS_DIR="${BATS_TEST_DIRNAME}/../tests/mocks/"
export PATH_MOCKS="${PATH_MOCKS_DIR}:${PATH}"

function setFzfMock()
{
	# shellcheck disable=SC2329     # SC2329: This function is never invoked. Check usage (or ignored if invoked indirectly).
	function fzf()
	{
		local output=

		[[ ${1:-} == "--bash" ]] && {
			printf '%s\n' '__fzf_list_hosts() { printf "myServer" ; }'
			return 0
		}

		IFS= read -d $'\t' -r output < "${FZF_MOCK_OUTPUT_FILE}" || :
		perl -0777 -i -pe 's/\A[^\t]*\t//' "${FZF_MOCK_OUTPUT_FILE}"

		printf '%s' "${output}"
	}

	export -f fzf

	export FZF_MOCK_OUTPUT=( "$@" )
	export FZF_MOCK_OUTPUT_FILE=

	FZF_MOCK_OUTPUT_FILE=$( mktemp )

	printf '%s\t' "${FZF_MOCK_OUTPUT[@]}" > "${FZF_MOCK_OUTPUT_FILE}"
}

function stripColors()
{
	printf '%s' "$*" | sed $'s/\033\\[[0-9;]*m//g'
}

function teardown()
{
	[[ -z "${FZF_MOCK_OUTPUT_FILE:-}" ]] || rm -f "${FZF_MOCK_OUTPUT_FILE}"
}
