#!/bin/bash
#set -ex
get_suffix_from_branch_name() {
    local branch_name=$1
    local branch_suffix=""
    if [[ "$branch_name" == master ]]; then 
        branch_suffix=""
    elif [[ "$branch_name" == "release"* ]]; then 
        branch_suffix="rc"
    elif [[ "$branch_name" == "develop"* ]]; then 
        branch_suffix="beta"
    elif [[ "$branch_name" == "feature"* ]]; then 
        branch_suffix="alpha"; 
    else
        branch_suffix="pre"; 
    fi
    echo $branch_suffix
}

get_branch_suffix() {
    local branch_name="$(get_branch_name)"
    echo "$(get_suffix_from_branch_name $branch_name)"
}

get_branch_name() {
    local branch_name=""
    
    if [[ "$APPVEYOR" == true ]]; then
        rev=$APPVEYOR_PULL_REQUEST_NUMBER
        branch_name=$APPVEYOR_REPO_BRANCH #APPVEYOR grabs HEAD, instead of branch_name, for many types of commits. This confuses git-ver. So override it.
    else
        branch_name=$(git rev-parse --abbrev-ref HEAD)
    fi

    echo "$branch_name"
}

get_tag_suffix() {
    echo "$( get_tag | sed -e 's/\(.*\)\([-]\)\(.*\)/\3/')"
}

get_tag() {
    local my_branch="$(get_branch_name)"
    local my_suffix="$(get_suffix_from_branch_name $branch)"
    echo $(git name-rev $my_branch --name-only --refs=v*$my_suffix*)
}

get_version() {
    local branch=$(get_branch_name)
    local ver=""
    if [[ "$branch" == "release"* ]]; then 
        ver=$( $branch | sed -e 's/[^0-9.]//g')
    elif [[ "$APPVEYOR" == true ]]; then
        ver=$APPVEYOR_BUILD_VERSION
    elif [[ "$VersionPrefix" != "" ]]; then
        ver=$VersionPrefix
    elif [[ "$Version" != "" ]]; then
        ver=$Version
    fi

    if [[ "$ver" == "" ]]; then 
        local tag="$(get_tag)"
        ver="$( echo $tag | sed -e 's/\(.*\)\([-].*\)/\1/' | sed 's/[^0-9.]//g')"
    fi;
    if [[ "$ver" == "" ]]; then ver="0.0.1"; fi;
    echo $ver    
}

get_suffix() {
    # local system defaults. These are overridden by appveyor
    local suffix=$(get_branch_suffix)
    if [[ ( "$1" == "--rev" || "$1" == "-r" ) && "$suffix" != "" ]]; then                 
        local rev="$(get_rev)"
        if [[ "$rev" -gt 0 ]]; then suffix="$suffix+r$rev"; fi;
    fi

    if [[ ( "$1" == "--date" || "$1" == "-d" ) && "$suffix" != "" ]]; then 
        suffix="$suffix+d$(date -u '+%Y%m%d-%H%M%S')"; 
    fi

    echo $suffix
}

get_rev() {
    local rev=0
    # count commits since last tag in this branch
    local suffix=$(get_branch_suffix)
    local last_tag_ref=$(git rev-list --no-walk --max-count=1 --tags=v*$suffix*)

    if [[ "$last_tag_ref" == "" ]]; then
        rev=0
    else
        # count commits since last tag.
        local rsl=$(git rev-list $last_tag_ref..HEAD --count)
        local last_tag="$(git name-rev $(get_branch_name) --name-only --refs=v*$suffix*)"

        #extract the rev (if any) from the current tag.
        local rft=$(echo $last_tag | sed -e 's/\(.*[-].*\)\([r][0-9]\)/\2/' | sed -e 's/[^0-9]//g')
        
        rev=$(expr $rsl + $rft)
    fi
    
    echo "$rev"
}

get_prefix() {
    echo "v$(get_version)"
}