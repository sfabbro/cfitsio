#!/bin/sh

domake() {
    echo -n " >>> Running make ${1} ... "
    make -j2 ${1} &> ${1}.log
    if [ $? -ne 0 ]; then
	echo "error for target ${1}, see cfitsio-build/${1}.log"
	exit
    fi
    echo "OK"
}

P="${1:-$(ls -1rt cfitsio-*.tar.gz | tail -n 1 | sed 's/.tar.gz//')}"
tar xfz ${P}.tar.gz
mkdir -p cfitsio-build
pushd cfitsio-build &> /dev/null
echo -n " >>> Installation prefix directory [/usr/local]: "
read dir
[ -z "${dir}" ] && dir="/usr/local"

echo -n " >>> Configuring cfitsio ... "
../${P}/configure \
    --disable-static \
    --prefix="${dir}" \
    CFLAGS="${CFLAGS:--O2}" FFLAGS="${FFLAGS:--O2}" \
    &> configure.log || \
    echo "error during configuration see cfitsio-build/configure.log"
[ $? -ne 0 ] && exit
echo "OK"

domake all
domake check
domake install
popd &> /dev/null
echo " >>> cfitsio library and execs are now installed"
rm -rf ${P} cfitsio-build

if [ "$(type -p imcopy)" != "${dir}/bin/imcopy" ]; then
    echo
    echo "To use the execs, you need to define the variable PATH as:"
    echo
    echo "      ${dir}/bin:\${PATH}"
    echo
fi

if [ "$(pkg-config --libs-only-L cfitsio)" != "-L${dir}/lib" ]; then
    echo
    echo "To compile with it, you need to define the variable PKG_CONFIG_PATH as:"
    echo
    echo "      ${dir}/lib:\${PKG_CONFIG_PATH}"
    echo
fi
