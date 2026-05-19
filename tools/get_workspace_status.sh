#!/bin/bash -u

git_rev=$(git rev-parse HEAD)
if [[ $? != 0 ]]; then
    exit 1
fi
echo "STABLE_BUILD_SCM_REVISION ${git_rev}"

git_short_rev=$(git rev-parse --short HEAD)
if [[ $? != 0 ]]; then
    exit 1
fi
echo "STABLE_BUILD_SCM_SHORT_REVISION ${git_short_rev}"

# Check whether there are any uncommitted changes
git diff-index --quiet HEAD --
if [[ $? == 0 ]]; then
    tree_status="Clean"
else
    tree_status="Modified"
fi
echo "STABLE_BUILD_SCM_STATUS ${tree_status}"
