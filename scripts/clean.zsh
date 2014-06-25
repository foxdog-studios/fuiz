#!/usr/bin/env zsh

repo=$(realpath "$(dirname "$(realpath -- $0)")/..")

function clean()
{
    rm --force --recursive --verbose $1
}

clean $repo/build
clean $repo/src/.meteor/local

while read -r package; do
    clean $package
done < $repo/src/packages/.gitignore

