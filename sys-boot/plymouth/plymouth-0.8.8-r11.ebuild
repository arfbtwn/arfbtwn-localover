# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/plymouth/plymouth-0.8.8-r4.ebuild,v 1.2 2013/10/20 07:41:42 pacho Exp $

EAPI=5

inherit autotools-utils readme.gentoo systemd toolchain-funcs

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="http://cgit.freedesktop.org/plymouth/"
SRC_URI="
	http://www.freedesktop.org/software/plymouth/releases/${P}.tar.bz2
	http://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="branding debug gdm +libkms +drm +logviewer +pango static-libs systemd"

CDEPEND="
	>=media-libs/libpng-1.2.16
	logviewer? (
		dev-libs/glib:2
		>=x11-libs/gtk+-2.12:2 )
	drm? ( x11-libs/libdrm )
	libkms? ( x11-libs/libdrm[libkms] )
	pango? ( >=x11-libs/pango-1.21 )
	systemd? ( sys-apps/systemd )
	gdm? ( gnome-base/gdm )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	virtual/udev
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	http://dev.gentoo.org/~aidecoe/doc/en/plymouth.xml
"

src_prepare() {
	sed -i 's:/bin/systemd-tty-ask-password-agent:/usr/bin/systemd-tty-ask-password-agent:g' \
		systemd-units/systemd-ask-password-plymouth.service.in || die \
		'ask-password sed failed'
	sed -i 's:/bin/udevadm:/usr/bin/udevadm:g' \
		systemd-units/plymouth-start.service.in || die 'udevadm sed failed'
	autotools-utils_src_prepare
}

src_configure() {
	local mytty=tty1
	local myeconfargs=(
		--with-release-file=/etc/gentoo-release
		--with-system-root-install=yes
		--localstatedir=/var
		--without-rhgb-compat-link
		--with-background-color=0x000000
		--with-background-start-color-stop=0x000000
		--with-background-end-color-stop=0x000000
		--with-boot-tty=/dev/$mytty
		--with-shutdown-tty=/dev/$mytty
		$(use_enable static-libs static)
		$(use_enable logviewer gtk)
		$(use_with logviewer log-viewer)
		$(use_enable systemd systemd-integration)
		$(use_enable debug tracing)
		$(use_enable libkms)
		$(use_enable pango)
		$(use_enable gdm gdm-transition)
		$(use_enable drm)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Install the eselect module
	insinto /usr/share/eselect/modules
	doins "${FILESDIR}"/plymouth-logo.eselect

	# Install the gentoo logo to the sysconf dir
	insinto /etc/plymouth
	doins "${DISTDIR}"/gentoo-logo.png

	# Move the bizcom icon
	mv  "${D}"/usr/share/plymouth/bizcom.png "${D}"/etc/plymouth/bizcom.png

	# If the user specifies branding then set the symlink
	use branding && (
		dosym /etc/plymouth/gentoo-logo.png /usr/share/plymouth/bizcom.png
	)

	# Install compatibility symlinks as some rdeps hardcode the paths
	dosym /bin/plymouth /usr/bin/plymouth
	dosym /sbin/plymouthd /usr/sbin/plymouthd
	dosym /usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut[dracut_modules_plymouth]" && ! has_version "sys-kernel/genkernel-next[plymouth]"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut[dracut_modules_plymouth] or sys-kernel/genkernel-next[plymouth]."
	fi
}
