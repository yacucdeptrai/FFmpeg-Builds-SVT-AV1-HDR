#!/bin/bash

# Official SVN at svn.xvid.org is often unavailable (HTTP 503). Use Debian's
# immutable orig tarball for the same upstream 1.3.7 release (SVN used r2202).
SCRIPT_URL="https://deb.debian.org/debian/pool/main/x/xvidcore/xvidcore_1.3.7.orig.tar.bz2"
SCRIPT_SHA256="aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"

ffbuild_enabled() {
    [[ $VARIANT == lgpl* ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    echo "retry-tool sh -c \"rm -rf xvid xvidcore.tar.bz2 && wget -qO xvidcore.tar.bz2 '$SCRIPT_URL' && echo '$SCRIPT_SHA256  xvidcore.tar.bz2' | sha256sum -c - && mkdir xvid && tar -xjf xvidcore.tar.bz2 -C xvid --strip-components=1\" && cd xvid"
}

ffbuild_dockerbuild() {
    cd build/generic

    # The original code fails on a two-digit major...
    sed -i\
        -e 's/GCC_MAJOR=.*/GCC_MAJOR=10/' \
        -e 's/GCC_MINOR=.*/GCC_MINOR=0/' \
        configure.in

    ./bootstrap.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$CFLAGS -std=gnu99"

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

    if [[ $TARGET == win* ]]; then
        rm -f "$FFBUILD_DESTPREFIX"/{bin/libxvidcore.dll,lib/libxvidcore.dll.a}
        rm -f "$FFBUILD_DESTPREFIX"/{bin/xvidcore.dll,lib/xvidcore.dll.a}
    elif [[ $TARGET == linux* ]]; then
        rm -f "$FFBUILD_DESTPREFIX"/lib/libxvidcore.so*
        rm -f "$FFBUILD_DESTPREFIX"/lib/xvidcore.so*
    fi
}

ffbuild_configure() {
    echo --enable-libxvid
}

ffbuild_unconfigure() {
    echo --disable-libxvid
}
