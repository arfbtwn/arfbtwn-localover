# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop/monodevelop-9999.ebuild $

EAPI=5
inherit fdo-mime gnome2-utils eutils versionator git-2

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"

EGIT_REPO_URI="git://github.com/mono/monodevelop.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
#IUSE="+git +subversion"
IUSE=""

RDEPEND=">=dev-lang/mono-3.0.1
	>=dev-dotnet/gnome-sharp-2.24.2-r1
	>=dev-dotnet/gtk-sharp-2.12.21
	>=dev-dotnet/mono-addins-1.0[gtk]
	>=dev-dotnet/xsp-2
	dev-util/ctags
	sys-apps/dbus[X]
	>=virtual/monodoc-2.0
	|| (
		www-client/firefox
		www-client/firefox-bin
		www-client/seamonkey
		)
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info"

MAKEOPTS="${MAKEOPTS} -j1" #nowarn
src_configure() {
#	./configure --prefix=/usr \
#		--disable-update-mimedb \
#		--disable-update-desktopdb \
#		--enable-monoextensions \
#		--enable-gnomeplatform \
#		$(use_enable subversion) \
#		$(use_enable git) || die
	./configure --prefix=/usr || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
