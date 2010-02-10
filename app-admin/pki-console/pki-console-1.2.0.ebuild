# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

RPM_REV="-1"
inherit java-pkg-2 eutils java-ant-2 pki-dogtag

DESCRIPTION="PKI console for management of the CA, DRM, OCSP, and TKS subsystems"
HOMEPAGE="http://pki.fedoraproject.org"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="=dev-java/jss-4*
	>=dev-java/ldapsdk-4.0
	>=dev-java/idm-console-framework-1.1
	!app-admin/fedora-idm-console"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_prepare() {
	java-pkg_jarfrom ldapsdk-4.1 ldapjdk.jar
	java-pkg_jarfrom jss-3.4 xpclass.jar jss4.jar
	java-pkg_jarfrom idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
	    -Dldapjdk.local.location="${S}" \
	    -Djss.local.location="${S}" \
	    -Dconsole.local.location="${S}" \
		-Dspecfile=${PN}.spec \
		${antflags} \
				compile_java || die
}

src_install() {
	java-pkg_newjar "${S}"/build/fedora-idm-console-${MY_V}_en.jar 389-idm-console_en.jar
	java-pkg_dolauncher ${PN} --main com.netscape.management.client.console.Console \
				--pwd "/usr/share/dirsrv/html/java/" \
				--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\""

	doicon "${DISTDIR}"/fedora.png
	make_desktop_entry ${PN} "Port389 Management Console" fedora.png Network
}
