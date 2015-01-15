# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/youcompleteme/youcompleteme-20130910.ebuild,v 1.2 2013/09/10 10:41:22 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
USE_DOTNET=net40
inherit git-r3 cmake-utils dotnet python-single-r1 vim-plugin

SRC_URI=""
EGIT_REPO_URI="git://github.com/Valloric/YouCompleteMe.git"
EGIT_COMMIT="def392d24c7b4b34c0e8b95c400c9be94176b928"

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="http://valloric.github.io/YouCompleteMe/"

LICENSE="GPL-3"
IUSE="+clang test"
KEYWORDS="x86 amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	clang? ( >=sys-devel/clang-3.3 )
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	)"

CMAKE_IN_SOURCE_BUILD=1
CMAKE_USE_DIR=${S}/third_party/ycmd/cpp
XBUILD_DIR=third_party/ycmd/third_party/OmniSharpServer

VIM_PLUGIN_HELPFILES="${PN}"

pkg_setup() {
	python-single-r1_pkg_setup
	dotnet_pkg_setup
}

src_prepare() {
	if ! use test ; then
		sed -i '/^add_subdirectory( tests )/d' third_party/ycmd/cpp/ycm/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use clang CLANG_COMPLETER)
		$(cmake-utils_use_use clang SYSTEM_LIBCLANG)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use net40; then
	  exbuild_dir "${XBUILD_DIR}" net_4_0_Release
	fi
}

src_test() {
	# TODO: use system gmock/gtest
	cd "${S}"/cpp
	emake ycm_core_tests
	cd ycm/tests || die
	LD_LIBRARY_PATH="${EROOT}"/usr/$(get_libdir)/llvm \
		"${S}"/cpp/ycm/tests/ycm_core_tests || die

	cd "${S}"/python/ycm
	nosetests || die
}

src_install() {
	dodoc *.md
	rm -r *.md *.sh COPYING.txt ${CMAKE_USE_DIR} || die
	find python -name *test* -exec rm -rf {} + || die
	rm third_party/ycmd/libclang.so || die

	vim-plugin_src_install

	python_optimize "${ED}"
	python_fix_shebang "${ED}"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "optional dependencies:"
		elog "  dev-python/jedi (better python autocompletion)"
		elog
	fi
}
