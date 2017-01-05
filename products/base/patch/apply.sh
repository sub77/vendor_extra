#!/bin/bash

build_root=$(pwd)
patches_path="$build_root/vendor/extra/products/base/patch/"
pushd "$patches_path" > /dev/null
unset repos
for patch in `find -type f -name '*.patch'|cut -d / -f 2-|sort`; do
    # Strip patch title to get git commit title - git ignore [text] prefixes in beginning of patch title during git am
    title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch")
    absolute_patch_path="$patches_path/$patch"
    # Supported both path/to/repo_with_underlines/file.patch and path_to_repo+with+underlines/file.patch (both leads to path/to/repo_with_underlines)
    repo_to_patch="$(if dirname $patch|grep -q /; then dirname $patch; else dirname $patch |tr '_' '/'|tr '+' '_'; fi)"

    # echo -e "Is ${CL_BLU}$repo_to_patch${CL_RST} patched for ${CL_CYN}'$title'${CL_RST} ? "

        if [ ! -d $build_root/$repo_to_patch ] ; then
                echo "$repo_to_patch NOT EXIST! Go away and check your manifests. Skipping this patch."
                continue
        fi

    pushd "$build_root/$repo_to_patch" > /dev/null
        if git am $absolute_patch_path 2&> /dev/null; then
            echo -e ${CL_GRN}"\n * Patching base: ${CL_RST} "${CL_P}$title ${CL_RST}"in" ${CL_LB}$repo_to_patch ${CL_RST}
            source $build_root/build/envsetup.sh
            else
            git am --abort 2&> /dev/null
                    if ! git am -3 $absolute_patch_path &> /dev/null; then
                        echo -e ${CL_RED}"\n - Failed${CL_RST} - check basepatch: ${CL_PP}$title${CL_RST} in ${CL_BLU}$repo_to_patch${CL_RST}"
                    fi
        fi
    popd > /dev/null
done
popd > /dev/null
        echo -e ${CL_GRN} "\n * Setup basepatches\n" ${CL_RST}

