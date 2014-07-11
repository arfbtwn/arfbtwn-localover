# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils autotools mono-env gnome2-utils fdo-mime versionator git-2

DESCRIPTION="Import, organize, play, and share your music using a simple and powerful interface."
HOMEPAGE="http://banshee.fm/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/GNOME/banshee.git"
EGIT_HAS_SUBMODULES=1

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="daap doc ipod karma mtp soundmenu test udev web youtube +gst-sharp gst-native"

RDEPEND="
	>=dev-lang/mono-3
	gnome-base/gnome-settings-daemon
	sys-apps/dbus
	>=dev-dotnet/gio-sharp-0.3
	>=dev-dotnet/gnome-sharp-2
	>=dev-dotnet/gtk-sharp-2.99:3
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
	>=media-libs/gstreamer-1.0:1.0
	media-plugins/gst-plugins-gconf:0.10
	media-libs/musicbrainz:3
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	>=dev-dotnet/mono-addins-0.6.2[gtk]
	>=dev-dotnet/taglib-sharp-2.0.3.7
	>=dev-db/sqlite-3.4:3
	karma? ( >=media-libs/libkarma-0.1.0-r1 )
	daap? (	>=dev-dotnet/mono-zeroconf-0.8.0-r1 )
	doc? (
		virtual/monodoc
		>=app-text/gnome-doc-utils-0.17.3
	)
	ipod? ( >=media-libs/libgpod-0.8.2[mono] )
	mtp? (
		>=media-libs/libmtp-0.3.0
	)
	web? (
		>=net-libs/webkit-gtk-1.2.2:2
		>=net-libs/libsoup-gnome-2.26:2.4
	)
	youtube? (
		>=dev-dotnet/google-gdata-sharp-1.4
	)
	udev? (
		app-misc/media-player-info
		>=dev-dotnet/gudev-sharp-3.0
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
	)
	gst-sharp? (
		>=dev-dotnet/gstreamer-sharp-3.0
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare () {
	DOCS="AUTHORS HACKING NEWS README"

	# Don't build BPM extension when not wanted
	#if ! use bpm; then
	#	sed -i -e 's:Banshee.Bpm:$(NULL):g' src/Extensions/Makefile.am || die
	#fi

	## Don't append -ggdb, bug #458632, upstream bug #698217
	#sed -i -e 's:-ggdb3:$(NULL):g' libbanshee/Makefile.am || die
	#sed -i -e 's:-ggdb3::g' src/Core/Banshee.WebBrowser/libossifer/Makefile.am || die

	epatch_user

	AT_M4DIR="-I build/m4/banshee -I build/m4/shamrock -I build/m4/shave" \
	eautoreconf

	intltoolize --force --copy --automake || die "intltoolize failed"
}

src_configure() {
	local myconf="--disable-dependency-tracking
		--disable-static
		--disable-maintainer-mode
		--enable-gnome
		--enable-schemas-install
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--disable-boo
		--disable-torrent
		--disable-shave
		--disable-ubuntuone
		--disable-upnp"

	econf \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
		$(use_enable mtp) \
		$(use_enable daap) \
		$(use_enable ipod appledevice) \
		$(use_enable karma) \
		$(use_enable soundmenu) \
		$(use_enable web webkit) \
		$(use_enable youtube) \
		$(use_enable udev gio) \
		$(use_enable udev gio_hardware) \
		$(use_enable gst-sharp) \
		$(use_enable gst-native) \
		${myconf}
}

src_compile() {
	emake MCS=/usr/bin/mcs
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
