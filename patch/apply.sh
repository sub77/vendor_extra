build_root=$(pwd)

patches_path="$build_root/$pvar/"
pushd "$patches_path" > /dev/null
unset repos
unset dirnameold

for patch in `find -type f -name '*.patch'|cut -d / -f 2-|sort`; do
     title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch");
     absolute_patch_path="$patches_path/$patch";
     repo_to_patch="$(if dirname $patch|grep -q /; then dirname $patch; else dirname $patch |tr '_' '/'|tr '+' '_'; fi)"
         if [[ $(dirname $patch) == $dirnameold ]]; then
             printf "${bldblu}$repo_to_patch${rst}"
         else
             echo -e;
             printf "${bldblu}$repo_to_patch${rst}"
         fi;
         dirnameold=$(dirname $patch);

        if [ `echo $build_root/$repo_to_patch | cut -d '-' -f2` == "bak" ] ; then
                echo -en ${bldylw} "DISABLED!"${par}
                continue
        else
        if [ ! -d $build_root/$repo_to_patch ] ; then
                echo -en ${bldred} "$repo_to_patch NOT EXIST! Skipping this patch."${par}
                continue
        fi
        fi

    pushd "$build_root/$repo_to_patch" > /dev/null
    if (git log |fgrep -qm1 "$title" ); then
        echo -n
      commit_hash=$(git log --oneline |fgrep -m1 "$title"|cut -d ' ' -f 1)
      if [ q"$commit_hash" != "q" ]; then
          commit_id=$(git format-patch -1 --stdout $commit_hash |git patch-id|cut -d ' ' -f 1)
          patch_id=$(git patch-id < $absolute_patch_path|cut -d ' ' -f 1)
          if [ "$commit_id" = "$patch_id" ]; then
              echo -en ${bldylw}" [*]" ${bldcya}$title ${par}
          else
          if patch $patch_args -p1 < $filename --dry-run | grep -e 'applied' &>/dev/null; then
            echo -en ${bldylw}" [*]" ${bldcya}$title ${par}
            git am $absolute_patch_path || git am --abort
          fi
      fi
    else
        echo "Unable to get commit hash for '$title'! Something went wrong!"
        sleep 20
    fi
    else
        echo -en ${bldgrn}" [*]" ${bldcya}$title ${par}
        if ! git am $absolute_patch_path &>/dev/null; then
            echo -e ${CL_RED}"Failed, aborting git am"${CL_RST}
            git am --abort
                echo -e ${CL_RED}"Retry git am -3"${CL_RST}
                    if ! git am -3 $absolute_patch_path &>/dev/null; then
                        echo -e ${CL_RED}"Failed -3, aborting git am"${CL_RST}
                        git am --abort
                        apply $absolute_patch_path $*
                    fi
        fi
    fi
    popd > /dev/null
done
popd > /dev/null
