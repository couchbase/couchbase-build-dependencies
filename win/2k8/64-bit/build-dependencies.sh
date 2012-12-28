#building all of the required dependencies for ubuntu 64-bit
# curl , libevent, v8, icu4c, gperftools, snappy and erlang otp
currentdir=`pwd`
rm -rf curl-7.21.4*
rm -rf /opt/couchbase/*
wget wget http://s3.amazonaws.com/couchbase-grommit/curl-7.21.4-DEV.tar.gz
tar -xvf curl-7.21.4-DEV.tar.gz
cd curl-7.21.4-DEV
./configure --prefix=/opt/couchbase --without-ssl --disable-shared --disable-ldap --disable-ldaps --without-libidn CFLAGS="-O2 -g"
LD_RUN_PATH=/opt/couchbase/lib make
LD_RUN_PATH=/opt/couchbase/lib make install
tar -zcvf win-2k8--x86-64-curl-7.21.4-DEV.tar.gz /opt/couchbase/
cp win-2k8--x86-64-curl-7.21.4-DEV.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf libevent-2.0.11-stable
wget https://github.com/downloads/libevent/libevent/libevent-2.0.11-stable.tar.gz
tar -xvf libevent-2.0.11-stable.tar.gz
cd libevent-2.0.11-stable
./configure --prefix=/opt/couchbase --disable-openssl --host=x86_64-w64-mingw32 --enable-shared --disable-static CFLAGS="-O2 -g"
make
make install
tar -zcvf win-2k8--x86-64-libevent-2.0.11-stable.tar.gz /opt/couchbase/
cp win-2k8--x86-64-libevent-2.0.11-stable.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf gperftool
git clone git://github.com/couchbase/gperftools.git
cd gperftools
git reset --hard 8f60ba949fb8576c530ef4be148bff97106ddc59
./configure --prefix=/opt/couchbase --host=x86_64-w64-mingw32 --disable-static --enable-shared --disable-cpu-profiler --disable-heap-checker --disable-heap-profiler --enable-minimal --disable-debugalloc --disable-dependency-tracking
./configure --prefix=/opt/couchbase --disable-static --enable-minimal CFLAGS="-O2 -g" CXXFLAGS=-DTCMALLOC_SMALL_BUT_SLOW
make install
tar -zcvf win-2k8--x86-64-gperftools-8f60b.tar.gz /opt/couchbase/
cp win-2k8--x86-64-gperftools-8f60b.tar.gz $currentdir/
cd $currentdir
rm -rf /opt/couchbase/*
rm -rf snappy
git clone git://github.com/couchbase/snappy
cd snappy
git reset --hard 5681dde156e9d07adbeeab79666c9a9d7a10ec95
./configure --prefix=/opt/couchbase --host=x86_64-w64-mingw32 --enable-shared --disable-static CFLAGS="-O2 -g "
make LDFLAGS=" -no-undefined"
make install
tar -zcvf win-2k8--x86-64-snappy-894be7.tar.gz /opt/couchbase/
cp win-2k8--x86-64-snappy-894be7.tar.gz  $currentdir/
cd $currentdir
#rm -rf /opt/couchbase/*
#rm -rf v8
#git clone git://github.com/couchbase/v8
#git checkout 3.9.7
#scons -j 8 arch=x86_64 mode=release snapshot=on library=shared visibility=default
#cp libv8.* /opt/couchbase/lib
#cp include/* /opt/couchbase/include
#echo "447decb75060a106131ab4de934bcc374648e7f2" > /opt/couchbase/lib/libv8.ver
#tar -zcvf win-2k8--x86-64-v8-3.9.7.tar.gz /opt/couchbase/
#cp win-2k8--x86-64-v8-3.9.7.tar.gz $currentdir/