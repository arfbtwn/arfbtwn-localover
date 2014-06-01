# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit base autotools git-2

SLOT="2"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-dotnet/gtk-sharp:3"
RESTRICT="test"

EGIT_REPO_URI="http://anongit.freedesktop.org/git/gstreamer/gstreamer-sharp.git"

src_prepare() {
	sed -i 's#cp $(API) $(gapidir)#cp $(API) $(DESTDIR)$(gapidir)#' "${S}/sources/Makefile.am"
	eautoreconf
}

src_compile() {
	emake
}

src_install() {
	gapidir=`pkg-config --variable=gapidir gtk-sharp-3.0`
	mkdir -p ${D}${gapidir}
	emake DESTDIR="${D}" install
}
