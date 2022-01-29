# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Swift programming language from Apple"
HOMEPAGE="www.swift.org"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI="https://api.github.com/repos/apple/swift/tarball/main -> swift-main.tar
			https://api.github.com/repos/apple/swift-cmark/tarball/main -> swift-cmark-main.tar.gz
			https://api.github.com/repos/apple/swift-llbuild/tarball/main -> swift-llbuild-main.tar.gz
			https://api.github.com/repos/apple/swift-argument-parser/tarball/0.3.0 -> swift-argument-parser-0.3.0.tar
			https://api.github.com/repos/apple/swift-driver/tarball/main -> swift-driver-main.tar
			https://api.github.com/repos/apple/swift-tools-support-core/tarball/main -> swift-tools-support-core-main.tar
			https://api.github.com/repos/apple/swift-package-manager/tarball/main -> swift-package-manager-main.tar
			https://api.github.com/repos/apple/swift-syntax/tarball/main -> swift-syntax-main.tar
			https://api.github.com/repos/apple/swift-stress-tester/tarball/main -> swift-stress-tester-main.tar
			https://api.github.com/repos/apple/swift-corelibs-xctest/tarball/main -> swift-corelibs-xctest-main.tar
			https://api.github.com/repos/apple/swift-corelibs-foundation/tarball/main -> swift-corelibs-foundation-main.tar
			https://api.github.com/repos/apple/swift-corelibs-libdispatch/tarball/main -> swift-corelibs-libdispatch-main.tar
			https://api.github.com/repos/apple/swift-integration-tests/tarball/main -> swift-integration-tests-main.tar
			https://api.github.com/repos/jpsim/Yams/tarball/3.0.1 -> yams-3.0.1.tar
			https://api.github.com/repos/apple/indexstore-db/tarball/main -> indexstore-db-main.tar
			https://api.github.com/repos/apple/sourcekit-lsp/tarball/main -> sourcekit-lsp-main.tar
			https://api.github.com/repos/apple/swift-format/tarball/main -> swift-format-main.tar
			https://api.github.com/repos/apple/llvm-project/tarball/apple/main -> llvm-project-main.tar"
else
	SRC_URI="https://api.github.com/repos/apple/swift/tarball/release/${PV} -> swift-${PV}.tar
			https://api.github.com/repos/apple/swift-cmark/tarball/release/${PV} -> swift-cmark-${PV}.tar
			https://api.github.com/repos/apple/swift-llbuild/tarball/release/${PV} -> swift-llbuild-${PV}.tar
			https://api.github.com/repos/apple/swift-argument-parser/tarball/0.3.0 -> swift-argument-parser-0.3.0.tar
			https://api.github.com/repos/apple/swift-driver/tarball/release/${PV} -> swift-driver-${PV}.tar
			https://api.github.com/repos/apple/swift-tools-support-core/tarball/release/${PV} -> swift-tools-support-core-${PV}.tar
			https://api.github.com/repos/apple/swift-package-manager/tarball/release/${PV} -> swift-package-manager-${PV}.tar
			https://api.github.com/repos/apple/swift-syntax/tarball/release/${PV} -> swift-syntax-${PV}.tar
			https://api.github.com/repos/apple/swift-stress-tester/tarball/release/${PV} -> swift-stress-tester-${PV}.tar
			https://api.github.com/repos/apple/swift-corelibs-xctest/tarball/release/${PV} -> swift-corelibs-xctest-${PV}.tar
			https://api.github.com/repos/apple/swift-corelibs-foundation/tarball/release/${PV} -> swift-corelibs-foundation-${PV}.tar
			https://api.github.com/repos/apple/swift-corelibs-libdispatch/tarball/release/${PV} -> swift-corelibs-libdispatch-${PV}.tar
			https://api.github.com/repos/apple/swift-integration-tests/tarball/release/${PV} -> swift-integration-tests-${PV}.tar
			https://api.github.com/repos/jpsim/Yams/tarball/3.0.1 -> yams-3.0.1.tar
			https://api.github.com/repos/apple/indexstore-db/tarball/release/${PV} -> indexstore-db-${PV}.tar
			https://api.github.com/repos/apple/sourcekit-lsp/tarball/release/${PV} -> sourcekit-lsp-${PV}.tar
			https://api.github.com/repos/apple/swift-format/tarball/main -> swift-format-main.tar
			https://api.github.com/repos/apple/llvm-project/tarball/swift/release/${PV} -> llvm-project-${PV}.tar"
fi

S=${WORKDIR}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="repl foundation"
RESTRICT="repl? ( strip )"

# This is needed even though build script has a destdir option, apparently the doc target doesn't
# respect it unless it's a global ENV.
DESTDIR=${D}

DEPEND="${PYTHON_DEPS}
		sys-devel/clang
		dev-libs/icu-layoutex
		dev-util/systemtap
		"
RDEPEND="${DEPEND}
		repl? ( dev-libs/libedit
				!!dev-util/lldb
				sys-devel/lld )
		"
BDEPEND="${DEPEND}
		dev-vcs/git
		dev-lang/swig
		"
src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	cd ${WORKDIR}
	mv *-indexstore-db-* indexstore-db
	mv *-llvm-project-* llvm-project
	mv *-sourcekit-lsp-* sourcekit-lsp
	mv *-swift-argument-parser-* swift-argument-parser
	mv *-swift-cmark-* cmark
	mv *-swift-corelibs-foundation-* swift-corelibs-foundation
	mv *-swift-corelibs-libdispatch-* swift-corelibs-libdispatch
	mv *-swift-corelibs-xctest-* swift-corelibs-xctest
	mv *-swift-driver-* swift-driver
	mv *-swift-format-* swift-format
	mv *-swift-integration-tests-* swift-integration-tests
	mv *-swift-llbuild-* llbuild
	mv *-swift-package-manager-* swiftpm
	mv *-swift-stress-tester-* swift-stress-tester
	mv *-swift-syntax-* swift-syntax
	mv *-swift-tools-support-core-* swift-tools-support-core
	mv *-swift-* swift
	mv *-Yams-* yams
}

BARGS=""

multilib_src_configure() {
	cd ${WORKDIR}
	USE_LLDB=""
	USE_FOUNDATION=""
	if use repl ; then
		USE_LLDB=(--lldb)
		elog "Using LLDB"
	fi
	if use foundation ; then
		USE_FOUNDATION=(--foundation)
		elog "Using Foundation"
	fi
	BARGS="-R ${USE_LLDB} ${USE_FOUNDATION} --skip-ios --skip-watchos --skip-tvos --swift-darwin-supported-archs \"x86_64\" --skip-build-benchmarks --llvm-targets-to-build X86"
}

multilib_src_compile() {
	elog "${BARGS}"
	cd ${WORKDIR}
	./swift/utils/build-script ${BARGS}
}

multilib_src_install() {
	${WORKDIR}/swift/utils/build-script ${BARGS} \
											--install-all --install-destdir "${D}" || die
	mkdir ${D}/usr/lib64
	local FROM=${D}/usr/lib
	local TO=${D}/usr/lib64
	rm ${FROM}/libIndexStore.so
	mv ${FROM}/libsourcekitdInProc.so ${TO}
	mv ${FROM}/libIndexStore.so.10 ${TO}
	mv ${FROM}/libswiftDemangle.so ${TO}

	cd ${FROM}
	ln -sf ../lib64/libsourcekitdInProc.so
	ln -sf ../lib64/libswiftDemangle.so
	ln -sf ../lib64/libIndexStore.so.10
	ln -sf ../lib64/libIndexStore.so.10 libIndexStore.so

	if use repl ; then
	    cd ${FROM}
		mv ${FROM}/liblldb.so.10.0.0 ${TO}
		ln -sf ../lib64/liblldb.so.10 liblldb.so
		ln -sf ../lib64/liblldb.so.10.0.0 liblldb.so.10
		ln -sf ../lib64/liblldb.so.10.0.0
	fi

	cd ${D}/usr/bin
	rm clang* lld ld64.lld lld-link wasm-ld ld.lld
}

