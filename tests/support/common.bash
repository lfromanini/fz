#!/usr/bin/env bash

__PROJECT_ROOT="$( cd "${BATS_TEST_DIRNAME}"/.. && pwd )"

export PATH_BIN="${__PROJECT_ROOT}"/bin/
export PATH_MOCKS="${__PROJECT_ROOT}/tests/mocks/:${PATH}"

export FZF_MOCK_OUTPUT=""
