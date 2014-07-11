# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp-glib/dbus-sharp-glib-0.5.0.ebuild,v 1.7 2012/05/04 03:56:56 jdhore Exp $

EAPI=4
inherit mono git-2 autotools

DESCRIPTION="D-Bus for .NET: GLib integration module"
HOMEPAGE="https://github.com/mono/dbus-sharp-glib"
EGIT_REPO_URI="https://github.com/mono/dbus-sharp-glib.git"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/mono
	>=dev-dotnet/dbus-sharp-0.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user
	eautoreconf
}

pkg_setup() {
	DOCS="AUTHORS README"
}
