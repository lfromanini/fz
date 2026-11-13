#!/usr/bin/env bash

export FZ_BIN="${BATS_TEST_DIRNAME}/../bin/fz"

export PATH_MOCKS_DIR="${BATS_TEST_DIRNAME}/../tests/mocks/"
export PATH_MOCKS="${PATH_MOCKS_DIR}:${PATH}"

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

function setFzfMock()
{
	export FZF_MOCK_OUTPUT_FILE=
	FZF_MOCK_OUTPUT_FILE=$( mktemp "${BATS_TEST_TMPDIR}/bats.XXXXXX" )

	printf '%s\t' "$@" > "${FZF_MOCK_OUTPUT_FILE}"
}

function stripColors()
{
	printf '%s' "$*" | sed $'s/\033\\[[0-9;]*m//g'
}
