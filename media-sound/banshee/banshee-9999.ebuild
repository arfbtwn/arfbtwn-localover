# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils autotools mono-env gnome2-utils fdo-mime versionator git-r3

DESCRIPTION="Import, organize, play, and share your music using a simple and powerful interface."
HOMEPAGE="http://banshee.fm/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/arfbtwn/banshee.git"
EGIT_BRANCH="feature/lite"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test doc daap udev web gst-sharp +gst-native"

IUSE+=" gnome clutter"

IUSE+=" +nereid +halie +beroe +muinshee +treeview"

IUSE+=" +mass-storage +mtp ipod karma"

IUSE+=" user-help"

EXTENSIONS=$(echo extension-{amazonmp3,amazonmp3-store,audiobook,booscript,bpm,coverart,daap})
EXTENSIONS+=" "$(echo extension-{emusic,emusic-store,filesystemqueue,fixup,internetarchive})
EXTENSIONS+=" "$(echo extension-{internetradio,lastfm,lastfmstreaming,librarywatcher})
EXTENSIONS+=" "$(echo extension-{mediapanel,minimode,miroguide,mpris,multimediakeys})
EXTENSIONS+=" "$(echo extension-{notificationarea,nowplaying,opticaldisc})
EXTENSIONS+=" "$(echo extension-{playermigration,playqueue,podcasting})
EXTENSIONS+=" "$(echo extension-{remoteaudio,soundmenu,sqldebugconsole})
EXTENSIONS+=" "$(echo extension-{torrent,ubuntuone,upnp,wikipedia,youtube})

#  --enable-mediapanel     Enable Mediapanel Client

#  --enable-gio            Enable GIO for IO operations
#  --enable-gio-hardware   Enable GIO Hardware backend

IUSE+=" ${EXTENSIONS}"

REQUIRED_USE="^^ ( gst-sharp gst-native )
			  extension-daap? ( daap )
			  extension-remoteaudio? ( daap )
			  extension-youtube? ( web )
			  extension-wikipedia? ( web )"

RDEPEND="
	>=dev-lang/mono-3
	gnome-base/gnome-settings-daemon
	sys-apps/dbus
	>=dev-dotnet/gnome-sharp-2
	>=dev-dotnet/gtk-sharp-2.12.10
	>=media-libs/gstreamer-1.0:1.0
	media-plugins/gst-plugins-gconf:0.10
	media-libs/musicbrainz:3
	>=dev-dotnet/dbus-sharp-0.8.1
	>=dev-dotnet/dbus-sharp-glib-0.6
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
		>=net-libs/webkit-gtk-2.18
		net-libs/libsoup:2.4
	)
	udev? (
		app-misc/media-player-info
		>=dev-dotnet/gudev-sharp-3.0
		>=dev-dotnet/gio-sharp-0.3
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
	)
	gst-sharp? (
		>=dev-dotnet/gstreamer-sharp-3.0
	)
	extension-booscript? ( dev-lang/boo )
	extension-bpm? ( media-plugins/gst-plugins-soundtouch )
	extension-upnp? ( >=dev-dotnet/mono-upnp-0.1 )
	extension-youtube? (
		>=dev-dotnet/google-gdata-sharp-1.4
	)
	test? ( >=dev-dotnet/nunit-2.5 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare () {
	DOCS="AUTHORS HACKING NEWS README"

	eautoreconf
}

src_configure() {
	local gst="--enable-gst=native"
	if use gst-sharp; then
		gst=--enable-gst=managed
	fi

	local base="--disable-dependency-tracking
		--disable-static
		--disable-maintainer-mode
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--enable-shave
		--enable-release
		$(use_with daap)
		$(use_with web webkit)"

	local ext=
	for i in $EXTENSIONS
	do
		ext+=" $(use_enable $i ${i#extension-})"
	done

	econf \
		${base} \
		${gst} \
\
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
\
		$(use_enable gnome) \
		$(use_enable gnome schemas-install) \
		$(use_enable udev gio) \
		$(use_enable udev gio-hardware) \
\
		$(use_enable treeview) \
		$(use_enable beroe) \
		$(use_enable muinshee) \
		$(use_enable nereid) \
		$(use_enable halie) \
\
		$(use_enable mass-storage) \
		$(use_enable mtp) \
		$(use_enable ipod appledevice) \
		$(use_enable karma) \
\
		${ext}
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
