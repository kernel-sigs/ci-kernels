#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

install_dep() {
  sudo -E apt-get update && sudo apt-get install -y --no-install-recommends dmsetup openssh-client git binutils cpu-checker
  which containerd || sudo apt-get install -y --no-install-recommends containerd
}

install_cni() {
  export CNI_VERSION=v0.8.5
  export ARCH=$([ $(uname -m) = "x86_64" ] && echo amd64 || echo arm64)
  sudo -E mkdir -p /opt/cni/bin
  sudo -E curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | sudo tar -xz -C /opt/cni/bin
}

install_ignite() {
  export VERSION=v0.6.3
  export GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64")

  for binary in ignite ignited; do
    echo "Installing ${binary}..."
    sudo -E curl -sfLo ${binary} https://github.com/weaveworks/ignite/releases/download/${VERSION}/${binary}-${GOARCH}
    sudo -E chmod +x ${binary}
    sudo -E mv ${binary} /usr/local/bin
  done
}


main() {
  install_dep
  install_cni
  install_ignite
  sudo -E kvm-ok
}

main $*
