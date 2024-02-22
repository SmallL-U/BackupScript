#!/usr/bin/env bash

# Check whether the shell is bash
if [ -z "$BASH" ]; then
    echo "This script must be run with bash." 1>&2
    exit 1
fi

# Check has pigz
if ! command -v pigz &> /dev/null; then
    echo "This script requires pigz but it's not installed. Please install it and try again." 1>&2
    exit 1
fi

# Check has jq
if ! command -v jq &> /dev/null; then
    echo "This script requires jq but it's not installed. Please install it and try again." 1>&2
    exit 1
fi

# Check has rclone
if ! command -v rclone &> /dev/null; then
    echo "This script requires rclone but it's not installed. Please install it and try again." 1>&2
    exit 1
fi

# Check current shell has exec permission
if [ ! -x "$0" ]; then
    echo "This script must be run with exec permission." 1>&2
    exit 1
fi

# Change the working directory to the directory of the script
cd "$(dirname "$0")" || exit

# Open a subshell to ensure env isolation
(
# Execute the env.sh script
. ./scripts/env.sh || exit $?
# Execute the utils.sh script
. ./scripts/utils.sh || exit $?
# Execute the pre.sh script
. ./scripts/pre.sh || exit $?
# Execute the run.sh script
. ./scripts/run.sh || exit $?
# Execute the after.sh script
. ./scripts/after.sh || exit $?
)