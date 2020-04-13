#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

install_dep() {
    sudo -E apt-get update && sudo -E apt-get install -y cpu-checker 
    sudo -E kvm-ok
}
main() {
    install_dep
}

main $*
