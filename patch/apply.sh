#!/bin/bash

build_root=$(pwd)

patches_path="$build_root/$pvar"
pushd "$patches_path" > /dev/null
unset repos

for patch in `find -type f -name '*.patch'|cut -d / -f 2-|sort`; do
    title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch")
    absolute_patch_path="$patches_path/$patch"
    repo_to_patch="$(if dirname $patch|grep -q /; then dirname $patch; else dirname $patch |tr '_' '/'|tr '+' '_'; fi)"
    printf "%-45s %-75s %s" "${bldblu}$repo_to_patch${rst}" "$title"
    pushd "$build_root/$repo_to_patch" > /dev/null
    apply $absolute_patch_path $*
    popd > /dev/null
done
popd > /dev/null
