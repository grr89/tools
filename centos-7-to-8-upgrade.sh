set -x
yum install -y epel-release yum-utils rpmconf
rpmconf -a
package-cleanup --leaves
package-cleanup --orphans
yum install -y dnf
dnf -y remove yum yum-metadata-parser
rm -rf /etc/yum
dnf -y upgrade
dnf -y install http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-release-8.6-1.el8.noarch.rpm http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-8-6.el8.noarch.rpm http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-6.el8.noarch.rpm
dnf -y --best --allowerasing upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf clean all
rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools
dnf -y remove NetworkManager dracut-network.x86_64 python36-rpmconf
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf -y install kernel-core
dnf -y groupupdate Core "Minimal Install"
cat /etc/redhat-release
