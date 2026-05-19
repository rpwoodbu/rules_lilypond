#!/bin/bash -eu

# LilyPond wrapper script. Enables stamping revision number into output.

set -o pipefail

if [[ -n "${RULES_LILYPOND_STABLE_STATUS:-}" ]]; then
    # Parse the stable_status.txt to get STABLE_BUILD_SCM_REVISION and
    # STABLE_BUILD_SCM_STATUS, and place those in env vars (sans `STABLE_`
    # prefix). You can then use these in LilyPond files.
    while read -r key value; do
        case "${key}" in
            STABLE_BUILD_SCM_REVISION) export BUILD_SCM_REVISION="$value" ;;
            STABLE_BUILD_SCM_SHORT_REVISION) export BUILD_SCM_SHORT_REVISION="$value" ;;
            STABLE_BUILD_SCM_STATUS) export BUILD_SCM_STATUS="$value" ;;
        esac
    done < "${RULES_LILYPOND_STABLE_STATUS}"
fi

exec "${RULES_LILYPOND_BINARY}" "$@"
