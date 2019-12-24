# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils xdg

MY_PV="${PV}1"

DESCRIPTION="Editor to create games on the Unity engine"
HOMEPAGE="https://unity3d.com"

HASH="8e603399ca02"
SRC_URI_BASE="https://beta.unity3d.com/download/${HASH}"
SRC_URI="
	${SRC_URI_BASE}/LinuxEditorInstaller/Unity.tar.xz -> ${P}.tar.xz
"

LICENSE="Unity-EULA"
SLOT="2019"
KEYWORDS="-* ~amd64"
IUSE="android doc facebook ios mac webgl windows"
REQUIRED_USE="facebook? ( webgl windows )"
RESTRICT="bindist primaryuri strip test"

RDEPEND="
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc[multilib]
	sys-libs/libcap
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:3[X]
	x11-libs/libXtst
	x11-misc/xdg-utils
"

PDEPEND="
	android? ( ~app-editors/${PN}-android-${PV} )
	doc? ( ~app-editors/${PN}-doc-${PV} )
	facebook? ( ~app-editors/${PN}-facebook-${PV} )
	ios? ( ~app-editors/${PN}-ios-${PV} )
	mac? ( ~app-editors/${PN}-mac-${PV} )
	webgl? ( ~app-editors/${PN}-webgl-${PV} )
	windows? ( ~app-editors/${PN}-windows-${PV} )
"

MY_PNS="${PN}-${SLOT}"

S="${WORKDIR}"
QA_PREBUILT="*"

CHECKREQS_DISK_BUILD="3200M"

src_prepare() {
	sed -e "s/%SLOT%/${SLOT}/" -e "s/%MY_PNS%/${MY_PNS}/g" \
		"${FILESDIR}/${PN}.desktop" > "${T}/${MY_PNS}.desktop"

	default
}

src_install() {
	local unity_dir="/opt/${MY_PNS}"

	insinto "${unity_dir}"
	doins -r Editor

	make_wrapper "${MY_PNS}" "${unity_dir}/Editor/Unity"
	newicon -s 256 "Editor/Data/Resources/LargeUnityIcon.png" "${MY_PNS}.png"
	domenu "${T}/${MY_PNS}.desktop"
}