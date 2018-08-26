#!/bin/bash
top_regex="(.*)\\ by\\ (.*):\\ \\d*.*"
readarray -t lines < tmp
hashes=()

for line in "${lines[@]}" ; do
  if [[ "$line" =~ $top_regex ]]; then
    sha1_hash=${BASH_REMATCH[1]}
    hashes+=($sha1_hash)
  fi
done

unique_hashes=($(echo "${hashes[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for sha1_hash in "${unique_hashes[@]}" ; do
  git show $sha1_hash

  read -t 60 -p "Do you want to filter this hash?: " -r
  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    git show --quiet --pretty=format:"'%H' => '%s%n'," $sha1_hash >> filter_hashes.out
  fi
done
