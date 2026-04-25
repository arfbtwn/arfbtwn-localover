# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper desktop xdg

DESCRIPTION="Ebook management application"
HOMEPAGE="https://calibre-ebook.com/"
SRC_URI="
	amd64? ( https://download.calibre-ebook.com/${PV}/calibre-${PV}-x86_64.txz -> ${P}-x86_64.txz )
	arm64? ( https://download.calibre-ebook.com/${PV}/calibre-${PV}-arm64.txz -> ${P}-arm64.txz )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

DEPEND="
	amd64? ( >=sys-libs/glibc-2.35 )
	arm64? ( >=sys-libs/glibc-2.34 )

	>=media-libs/libglvnd-1.7.0
	>=x11-libs/xcb-util-cursor-0.1.6
	>=media-libs/freetype-2.14.3
"
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="strip"

CALIBRE_ROOT="/opt/${P}"
_PN="${PN%-bin}"

QA_PREBUILT="${CALIBRE_ROOT#/}/*"

src_unpack() {
	{ mkdir ${P} && cd ${P}; } || die
	default
}

src_configure() {
	:
}

src_compile() {
	:
}

src_test() {
	:
}

src_install() {
	insinto "${CALIBRE_ROOT}"

	exeinto "${CALIBRE_ROOT}"
	## Would be more robust/complete but
	## generates skip directory warnings
	# doexe ./*
	doexe calibre
	doexe calibre-*
	doexe ebook-*
	doexe fetch-ebook-metadata
	doexe lrf2lrs lrfviewer lrs2lrf
	doexe markdown-calibre
	doexe web2disk

	exeinto "${CALIBRE_ROOT}/bin"
	doexe bin/*
	exeinto "${CALIBRE_ROOT}/libexec"
	doexe libexec/*

	doins -r lib plugins resources share translations

	make_wrapper calibre ./calibre "${CALIBRE_ROOT}"
	make_desktop_entry --eapi9 calibre \
		-n "Calibre Ebook Manager" \
		-c "Utility" \
		-i "${_PN}"

	newicon resources/images/apple-touch-icon.png "${_PN}.png"
}
