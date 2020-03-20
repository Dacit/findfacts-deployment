#!/bin/bash

VERSION="0.2.1-SNAPSHOT"
SCHEMA_VERSION="0.2.1-SNAPSHOT"

shopt -s nullglob dotglob
root=$(dirname "$BASH_SOURCE")
if [[ ! -d $root/deployed ]]
then
  echo "Deployed folder $root/deployed does not exist"
  exit
fi
cd $root/templates || (echo "Templates folder $root/templates does not exist" && exit)

# Copy / Populate files
function copy_replacing() {
  files=("$1"/*)
  for file in "${files[@]}"
  do
    if [[ -d $file ]]
    then
      # Recurse files tree
      copy_replacing $file
    else
      # Replace vars in file name
      target=../deployed/$(eval echo $file)
      # Replace vars in file content
      mkdir -p "$(dirname $target)"
      (envsubst < $file) > $target
    fi
  done
}

copy_replacing "."