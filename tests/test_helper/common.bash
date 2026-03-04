#!/usr/bin/env bash

__PROJECT_ROOT="$( cd "${BATS_TEST_DIRNAME}"/.. && pwd )"

export FZ="${__PROJECT_ROOT}"/bin/fz
export PATH_MOCKS="${__PROJECT_ROOT}"/tests/mocks
