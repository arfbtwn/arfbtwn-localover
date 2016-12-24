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

IUSE="doc test udev web gst-sharp +gst-native"

IUSE+=" gnome"

IUSE+=" +nereid +halie +treeview"

IUSE+=" +dap +mass-storage mtp ipod karma"

IUSE+=" boo bpm coverart daap mpris playqueue soundmenu youtube upnp"

# TODO:
#
#  moonlight
#  tests
#  beroe
#  mediapanel
#  muinshee
#  gio
#  gio-hardware
#  remote-audio
#  torrent
#  ubuntuone
#  amazonmp3
#  amazonmp3-store
#  audiobook
#  emusic
#  emusic-store
#  filesystemqueue
#  fixup
#  internetarchive
#  internetradio
#  lastfm
#  lastfmstreaming
#  librarywatcher
#  mediapanel
#  minimode
#  miroguide
#  multimediakeys
#  notificationarea
#  nowplaying
#  opticaldisc
#  playermigration
#  podcasting
#  remoteaudio
#  sample
#  sqldebugconsole
#  torrent
#  ubuntuonemusicstore
#  wikipedia

RDEPEND="
	>=dev-lang/mono-3
	gnome-base/gnome-settings-daemon
	sys-apps/dbus
	>=dev-dotnet/gnome-sharp-2
	>=dev-dotnet/gtk-sharp-2.12.10
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
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
		>=net-libs/webkit-gtk-1.2.2:2
		>=net-libs/libsoup-gnome-2.26:2.4
	)
	youtube? (
		>=dev-dotnet/google-gdata-sharp-1.4
	)
	udev? (
		app-misc/media-player-info
		>=dev-dotnet/gudev-sharp-3.0
		>=dev-dotnet/gio-sharp-0.3
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
	)
	upnp? ( >=dev-dotnet/mono-upnp-0.1 )
	gst-sharp? (
		>=dev-dotnet/gstreamer-sharp-3.0
	)
	test? ( >=dev-dotnet/nunit-2.5 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare () {
	DOCS="AUTHORS HACKING NEWS README"

	epatch_user

	NOCONFIGURE=true ./autogen.sh
}

src_configure() {
	local myconf="--disable-dependency-tracking
		--disable-static
		--disable-maintainer-mode
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--disable-shave
		--enable-release"

	econf \
		${myconf} \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
\
		$(use_enable gst-sharp) \
		$(use_enable gst-native) \
\
		$(use_enable gnome) \
		$(use_enable gnome schemas-install) \
		$(use_enable udev gio) \
		$(use_enable udev gio-hardware) \
\
		$(use_enable treeview) \
		$(use_enable web webkit) \
		$(use_enable nereid) \
		$(use_enable halie) \
\
		$(use_enable dap) \
		$(use_enable mass-storage) \
		$(use_enable mtp) \
		$(use_enable ipod appledevice) \
		$(use_enable karma) \
\
		$(use_enable boo) \
		$(use_enable boo booscript) \
		$(use_enable bpm) \
		$(use_enable coverart) \
		$(use_enable daap) \
		$(use_enable mpris) \
		$(use_enable playqueue) \
		$(use_enable soundmenu) \
		$(use_enable upnp) \
		$(use_enable upnp upnpclient) \
		$(use_enable youtube)
#  moonlight
#  tests
#  beroe
#  mediapanel
#  muinshee
#  gio
#  gio-hardware
#  remote-audio
#  torrent
#  ubuntuone
#  treeview
#  amazonmp3
#  amazonmp3-store
#  audiobook
#  emusic
#  emusic-store
#  filesystemqueue
#  fixup
#  internetarchive
#  internetradio
#  lastfm
#  lastfmstreaming
#  librarywatcher
#  mediapanel
#  minimode
#  miroguide
#  multimediakeys
#  notificationarea
#  nowplaying
#  opticaldisc
#  playermigration
#  podcasting
#  remoteaudio
#  sample
#  sqldebugconsole
#  ubuntuonemusicstore
#  wikipedia
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
