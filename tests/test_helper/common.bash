#!/usr/bin/env bash

__PROJECT_ROOT="$( cd "${BATS_TEST_DIRNAME}"/.. && pwd )"

export BIN_FZ="${__PROJECT_ROOT}"/bin/fz
export PATH_MOCKS="${__PROJECT_ROOT}/tests/mocks/:${PATH}"

export FZF_MOCK_OUTPUT=""
export TMUX=""
