# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp/dbus-sharp-0.7.0-r1.ebuild,v 1.6 2012/08/18 12:24:40 xmw Exp $

EAPI="4"
inherit mono eutils git-2 autotools

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/arfbtwn/dbus-sharp"
#SRC_URI="mirror://github/arfbtwn/${PN}/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/arfbtwn/dbus-sharp.git"
EGIT_BRANCH="staging"

LICENSE="MIT"
SLOT="2.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/mono
	sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS README"
}

src_prepare() {
	epatch_user

	eautoreconf
}
