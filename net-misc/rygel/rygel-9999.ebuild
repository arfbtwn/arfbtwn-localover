# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rygel/rygel-0.18.4.ebuild,v 1.2 2013/09/08 17:19:38 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils autotools git-2

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="http://live.gnome.org/Rygel"
EGIT_REPO_URI="git://git.gnome.org/rygel"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test X nls +sqlite +tracker +transcode +mediaserver2 +mpris +mediathek +ruih +gstreamer +introspection"

# The deps for tracker? and transcode? are just the earliest available
# version at the time of writing this ebuild
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/libgee-0.8:0.8
	>=dev-libs/libxml2-2.7:2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/gssdp-0.13
	>=net-libs/gupnp-0.19
	>=net-libs/gupnp-av-0.12.4
	>=net-libs/libsoup-2.34:2.4
	media-libs/libmediaart:2.0[vala]
	>=sys-apps/util-linux-2.20
	x11-misc/shared-mime-info
	sqlite? (
		>=dev-db/sqlite-3.5:3
		dev-libs/libunistring
	)
	tracker? ( >=app-misc/tracker-0.16 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-soup:1.0
	)
	transcode? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-soup:1.0
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	X? ( >=x11-libs/gtk+-3:3 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-lang/vala-0.22.1
	>=dev-libs/vala-common-0.22.1
    dev-libs/libxslt
"
src_prepare() {
	epatch_user	
	eautoreconf

	# runs gst-plugins-scanner on run with triggers sandbox violation
	# trying to open dri
	if use test; then
		sed -e 's/rygel-media-engine-test$(EXEEXT)//' \
			-e 's/rygel-playbin-renderer-test$(EXEEXT)//' \
			-i tests/Makefile.in || die
	fi

}

#--enable-external-plugin enable MediaServer2 DBus consumer plugin
#--enable-mpris-plugin   enable MPRIS2 DBus consumer plugin
#--enable-mediathek-plugin enable ZDF Mediathek plugin
#--enable-ruih-plugin    enable Ruih plugin
#--enable-playbin-plugin enable GStreamer playbin plugin
#--enable-gst-launch-plugin enable GStreamer launchline plugin
#--enable-tracker-plugin enable Tracker plugin
src_configure() {
	media=simple
	if use gstreamer; then media=gstreamer; fi

	econf \
		--with-media-engine=$media \
		$(use_enable test tests) \
		$(use_enable nls) \
		$(use_enable introspection) \
		$(use_enable sqlite media-export-plugin) \
		$(use_enable tracker tracker-plugin) \
		$(use_enable mediaserver2 external-plugin) \
		$(use_enable mpris mpris-plugin) \
		$(use_enable mediathek mediathek-plugin) \
		$(use_enable ruih ruih-plugin) \
		$(use_enable gstreamer playbin-plugin) \
		$(use_enable gstreamer gst-launch-plugin) \
		$(use_with X ui)
}

src_compile() {
	emake;
}

src_install() {
	emake DESTDIR="${D}" install;

	if ! declare -p DOCS >/dev/null 2>&1 ; then
		local d;
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES THANKS BUGS \
			FAQ CREDITS CHANGELOG ; do
				[[ -s "${d}" ]] && dodoc "${d}";
		done
	elif declare -p DOCS | grep -q "^declare -a " ; then
		dodoc "${DOCS[@]}";
	else
		dodoc ${DOCS};
	fi

	# Autostart file is not placed correctly, bug #402745
	insinto /etc/xdg/autostart
	doins "${D}"/usr/share/applications/rygel.desktop
	rm "${D}"/usr/share/applications/rygel.desktop
}
