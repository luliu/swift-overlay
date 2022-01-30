# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Swift programming language from Apple"
HOMEPAGE="www.swift.org"

SRC_URI="https://download.swift.org/swift-${PV}-release/amazonlinux2/swift-${PV}-RELEASE/swift-${PV}-RELEASE-amazonlinux2.tar.gz"

S=${WORKDIR}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="repl icu"
RESTRICT="repl? ( strip )"

DEPEND="${PYTHON_DEPS}
		sys-devel/clang
		icu? ( dev-libs/icu-layoutex )
		dev-util/systemtap
		!!sys-devel/clang:10.0.0
		"
RDEPEND="${DEPEND}
		repl? ( dev-libs/libedit )
		dev-lang/python:3.7
		"

src_install() {
	ZIPDIR=swift-${PV}-RELEASE-amazonlinux2
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/clang-10
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/clangd

	dosym clang-10 /usr/bin/clang
	dosym clang /usr/bin/clang++
	dosym clang /usr/bin/clang-cl
	dosym clang /usr/bin/clang-cpp

	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/lld
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/lldb
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/lldb-argdumper
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/lldb-server
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/plutil
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/repl_swift
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/sourcekit-lsp
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-api-checker.py
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-build
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-build-sdk-interfaces
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-build-tool
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-demangle
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-driver
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-frontend
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-help
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-package
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-package-collection
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-run
	dobin ${WORKDIR}/${ZIPDIR}/usr/bin/swift-test

	dosym lld /usr/bin/ld64.lld
	dosym lld /usr/bin/ld64.lld
	dosym lld /usr/bin/ld64.lld.darwinnew
	dosym lld /usr/bin/ld.lld
	dosym lld /usr/bin/lld-link
	dosym lld /usr/bin/wasm-ld
	dosym swift-frontend /usr/bin/swift
	dosym swift-frontend /usr/bin/swift-api-digester
	dosym swift-frontend /usr/bin/swift-api-extract
	dosym swift-frontend /usr/bin/swift-autolink-extract
	dosym swift-frontend /usr/bin/swiftc
	dosym swift-frontend /usr/bin/swift-symbolgraph-extract
	dosym swift-frontend /usr/bin/swift-symbolgraph-extract

	doheader -r ${WORKDIR}/${ZIPDIR}/usr/include

	dolib.so ${WORKDIR}/${ZIPDIR}/usr/lib/libIndexStore.so.10git
	dolib.so ${WORKDIR}/${ZIPDIR}/usr/lib/liblldb.so.10.0.0git
	dolib.so ${WORKDIR}/${ZIPDIR}/usr/lib/libsourcekitdInProc.so
	dolib.so ${WORKDIR}/${ZIPDIR}/usr/lib/libswiftDemangle.so

	insinto /usr/lib
	doins -r ${WORKDIR}/${ZIPDIR}/usr/lib/swift
	doins -r ${WORKDIR}/${ZIPDIR}/usr/lib/swift_static

	dosym libIndexStore.so.10git /usr/lib64/libIndexStore.so
	dosym liblldb.so.10.0.0git /usr/lib64/liblldb.so.10git
	dosym liblldb.so.10git /usr/lib64/liblldb.so

	dosym ../lib64/libIndexStore.so /usr/lib/libIndexStore.so
	dosym ../lib64/libIndexStore.so.10git /usr/lib/libIndexStore.so.10git
	dosym ../lib64/liblldb.so /usr/lib/liblldb.so
	dosym ../lib64/liblldb.so.10.0.0git /usr/lib/liblldb.so.10.0.0git
	dosym ../lib64/liblldb.so.10git /usr/lib/liblldb.so.10git
	dosym ../lib64/libsourcekitdInProc.so /usr/lib/libsourcekitdInProc.so
	dosym ../lib64/libswiftDemangle.so /usr/lib/libswiftDemangle.so

	# We need to fix symlink path to clang
	#CLANG_VERSION=`clang --version | grep "clang version"`
	#CLANG_VERSION_TOKEN=($CLANG_VERSION)
	#dosym ../../lib/clang/${CLANG_VERSION_TOKEN[2]} /usr/lib64/swift/clang
	#dosym ../../lib/clang/${CLANG_VERSION_TOKEN[2]} /usr/lib64/swift_static/clang

	# Or use use Apple's Clang 10.0.0
	insinto /usr/lib/clang/
	doins -r ${WORKDIR}/${ZIPDIR}/usr/lib/clang/10.0.0

	insinto /usr/local
	doins -r ${WORKDIR}/${ZIPDIR}/usr/local/include

	dodoc -r ${WORKDIR}/${ZIPDIR}/usr/share/doc/swift

	insinto /usr/share
	doins -r ${WORKDIR}/${ZIPDIR}/usr/share/icuswift
	doins -r ${WORKDIR}/${ZIPDIR}/usr/share/swift

	doman ${WORKDIR}/${ZIPDIR}/usr/share/man/man1/*.1
}

