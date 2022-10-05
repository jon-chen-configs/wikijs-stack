#!/bin/sh

WD="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTS_DIR=${WD}/../../scripts
export STACK_NAME=wikijs-swarm

${SCRIPTS_DIR}/stack.remove.sh
