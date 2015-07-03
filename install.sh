# This is a one-off script that should be run to install the various scripts in this
# directory. It will symlink all the scripts in this directory to ~/bin.

function filename () {
  basename $1 | cut -f1 -d\.
}

function symlink_to_bin () {
  local filename_with_ext=$1
  local filename_without_ext=$(filename $filename_with_ext)
  ln -s $(pwd)/$filename_with_ext ~/bin/$filename_without_ext
}

function link_files_of_type () {
  local ext=$1
  for f in $(ls *.$ext | grep -v install.sh); do
    if ! [ -L ~/bin/$(filename $f) ]; then
      symlink_to_bin $f
    fi
  done
}

function chmod_files () {
  for f in $(ls ~/bin/); do
    chmod 777 ~/bin/$f
  done
}

function main () {
  link_files_of_type rb
  link_files_of_type sh
  chmod_files
  echo "All scripts were successfully linked."
}

main
