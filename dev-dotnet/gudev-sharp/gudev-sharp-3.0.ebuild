# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit mono-env autotools

DESCRIPTION="GUDEV API C# binding"
HOMEPAGE="https://github.com/mono/gudev-sharp"
SRC_URI="https://github.com/mono/${PN}/releases/download/3.0.0/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-dotnet/gtk-sharp
	virtual/libgudev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i 's#GENERATED_SOURCES=generated/\*.cs#GENERATED_SOURCES="generated/GUdev/*.cs generated/GtkSharp/*.cs"#' configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS
}
