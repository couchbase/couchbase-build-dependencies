#building all of the required dependencies for ubuntu 64-bit
# curl , libevent, v8, icu4c, gperftools, snappy and erlang otp
currentdir=`pwd`
rm -rf curl-7.21.4*
rm -rf /opt/couchbase/*
wget  http://curl.haxx.se/download/curl-7.21.4.tar.gz
tar -xvf curl-7.21.4.tar.gz
cd curl-7.21.4
./configure --prefix=/opt/couchbase --without-ssl --disable-shared --disable-ldap --disable-ldaps --without-libidn CFLAGS="-O2 -g"
LD_RUN_PATH=/opt/couchbase/lib make
LD_RUN_PATH=/opt/couchbase/lib make install
tar -zcvf ubuntu-10-04-x86-curl-7.21.4.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-curl-7.21.4.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf libevent-2.0.11-stable
wget https://github.com/downloads/libevent/libevent/libevent-2.0.11-stable.tar.gz
tar -xvf libevent-2.0.11-stable.tar.gz
cd libevent-2.0.11-stable
./configure --prefix=/opt/couchbase --disable-openssl CFLAGS="-O2 -g"
make
make install
tar -zcvf ubuntu-10-04-x86-libevent-2.0.11-stable.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-libevent-2.0.11-stable.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf v8
mkdir -p /opt/couchbase/lib
mkdir -p /opt/couchbase/include
git clone git://github.com/couchbase/v8
git checkout 3.9.7
scons -j 8 arch=ia32 mode=release snapshot=on library=shared visibility=default
cp libv8.* /opt/couchbase/lib
cp include/* /opt/couchbase/include
echo "447decb75060a106131ab4de934bcc374648e7f2" > /opt/couchbase/lib/libv8.ver
tar -zcvf ubuntu-10-04-x86-v8-3.9.7.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-v8-3.9.7.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf icu4c
git clone git://github.com/couchbase/icu4c
cd icu4c
cd source && ./configure "--prefix=/opt/couchbase"
cd ..
make -C source install
tar -zcvf ubuntu-10-04-x86-icu4c-894be7.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-icu4c-894be7.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf gperftool
wget http://gperftools.googlecode.com/files/gperftools-2.0.tar.gz
tar -xvf gperftools-2.0.tar.gz
cd gperftools-2.0
./configure --prefix=/opt/couchbase --disable-static --enable-minimal CFLAGS="-O2 -g" CXXFLAGS=-DTCMALLOC_SMALL_BUT_SLOW
make libtcmalloc_minimal.la
make install-exec-am install-data-am
tar -zcvf ubuntu-10-04-x86-gperftools-2.0.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-gperftools-2.0.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf snappy
git clone git://github.com/couchbase/snappy
cd snappy
git reset --hard 5681dde156e9d07adbeeab79666c9a9d7a10ec95
./configure --prefix=/opt/couchbase CFLAGS="-O2 -g "
make LDFLAGS=" -no-undefined"
make install
tar -zcvf ubuntu-10-04-x86-snappy-894be7.tar.gz /opt/couchbase/
cp ubuntu-10-04-x86-snappy-894be7.tar.gz  $currentdir/
#build sqlite , pysqlite with python 2.4 and then with python 2.6
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf *sqlite*
mkdir -p /opt/couchbase/lib/python
wget http://s3.amazonaws.com/couchbase-grommit/sqlite-3.7.2-all-src-1.zip
unzip sqlite-3.7.2-all-src-1.zip
cd sqlite-3.7.2-src
./configure --prefix=/opt/couchbase
make install
cd $currentdir
git clone git://github.com/couchbase/pysqlite.git
cd pysqlite
git clean -xfd
git reset --hard 0ff6e32ea05037fddef1eb41a648f2a2141009ea
python2.6 setup.py config -I /opt/couchbase/include -L /opt/couchbase/lib build
cd build/lib*
tar czf pysqlite2.tar pysqlite2
mv pysqlite2.tar /opt/couchbase/lib/python/
tar -zcvf ubuntu-10-04-x86-pysqlite-0ff6e.tar.gz /opt/couchbase
cp ubuntu-10-04-x86-pysqlite-0ff6e.tar.gz $currentdir/
#build ctypes
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf ctypes*
mkdir -p /opt/couchbase/lib/python
wget http://s3.amazonaws.com/couchbase-grommit/ctypes-1.0.2.tar.gz
tar -xvf ctypes-1.0.2.tar.gz
cd ctypes
python2.4 setup.py build \
cd build/lib*
tar cf ctypes.tar ctypes _ctypes.so
mv ctypes.tar /opt/couchbase/lib/python/
tar -zcvf ubuntu-10-04-x86-ctypes-1.0.2.tar.gz /opt/couchbase
cp ubuntu-10-04-x86-ctypes-1.0.2.tar.gz ../
#build otp
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf otp
rm -rf OTP
wget https://github.com/erlang/otp/archive/OTP_R14B04.tar.gz
tar -xvf OTP_R14B04.tar.gz
cd otp-OTP_R14B04
git apply otp_R14B02-64bit.patch || true
git apply 0001-disable-usage-of-futex-syscall.patch
git apply otp_R14B02-ssl-server.patch
LD_RUN_PATH=/opt/couchbase/lib ./otp_build autoconf
touch lib/wx/SKIP lib/megaco/SKIP
LD_RUN_PATH=/opt/couchbase/lib ./configure --prefix=/opt/couchbase --enable-smp-support --disable-hipe --disable-fp-exceptions CFLAGS="-O2 -g"
LD_RUN_PATH=/opt/couchbase/lib make
LD_RUN_PATH=/opt/couchbase/lib make install
tar -zcvf ubuntu-10-04-x86-otp-OTP_R14B04.tar.gz /opt/couchbase
cp ubuntu-10-04-x86-otp-OTP_R14B04.tar.gz $currentdir/