#!/bin/bash
# Build a Linux kernel, install it on a remote machine, and reboot the machine.
# This script is only known to work for Debian/Ubuntu-based FABRIC VMs.

set -e

VERBOSE=""

while getopts "h?vm:p:z:" opt; do
	case "${opt}" in
		h|\?)
			usage
			exit 0
			;;
		v)
			VERBOSE="set -x"
			;;
	esac
done

umask 022

${VERBOSE}

BRANCH=`git rev-parse --abbrev-ref HEAD | sed s/-/+/g`
SHA1=`git rev-parse --short HEAD`
LOCALVERSION=+${BRANCH}+${SHA1}+FABRIC
FABRIC_PKG_DIR=${PWD}/fabric/${LOCALVERSION}/pkg
FABRIC_INSTALL_DIR=${PWD}/fabric/${LOCALVERSION}/install
FABRIC_BUILD_DIR=${PWD}/fabric/${LOCALVERSION}/build
KERNEL_PKG=kernel-${LOCALVERSION}.tar.gz2
MAKE_OPTS="-j`nproc` \
           LOCALVERSION=${LOCALVERSION} \
           EXTRAVERSION="" \
           INSTALL_PATH=${FABRIC_INSTALL_DIR}/boot \
           INSTALL_MOD_PATH=${FABRIC_INSTALL_DIR}"

echo "cleaning..."
mkdir -p ${FABRIC_BUILD_DIR}
mkdir -p ${FABRIC_INSTALL_DIR}/boot
mkdir -p ${FABRIC_PKG_DIR}

set +e
echo "copying config.fabric to .config ..."
cp config.fabric .config
echo "running make olddefconfig ..."
make olddefconfig               > /tmp/make.olddefconfig
make ${MAKE_OPTS} prepare         > /tmp/make.prepare
echo "making..."
make ${MAKE_OPTS}                 > /tmp/make.default
echo "making modules ..."
make ${MAKE_OPTS} modules         > /tmp/make.modules
echo "making install ..."
make ${MAKE_OPTS} install         > /tmp/make.install
echo "making modules_install ..."
make ${MAKE_OPTS} modules_install > /tmp/make.modules_install
set -e

echo "making tarball ..."
(cd ${FABRIC_INSTALL_DIR}; tar -cvzf ${FABRIC_PKG_DIR}/${KERNEL_PKG}  boot/* lib/modules/* --owner=0 --group=0  > /tmp/make.tarball)

umask 027
