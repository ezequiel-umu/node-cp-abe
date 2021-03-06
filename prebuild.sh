urls="http://acsc.cs.utexas.edu/cpabe/libbswabe-0.9.tar.gz \
http://acsc.cs.utexas.edu/cpabe/cpabe-0.11.tar.gz \
https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"

deps="libbswabe-0.9.tar.gz \
cpabe-0.11.tar.gz \
pbc-0.5.14.tar.gz"

for dep in $deps
do
  rm $dep
done


echo "Downloading"

for url in $urls
do
  echo $url
  wget $url & > /dev/null
done

wait

echo "Extracting"

for dep in $deps
do
  echo $dep
  tar -xzf $dep & > /dev/null
done

wait

# Apply patches
patch -R cpabe-0.11/common.c patches/cpabe-0.11@common.c.patch
patch -R cpabe-0.11/common.h patches/cpabe-0.11@common.h.patch
patch -R cpabe-0.11/policy_lang.y patches/cpabe-0.11@policy_lang.y.patch
patch -R libbswabe-0.9/Makefile.in patches/libbswabe-0.9@Makefile.in.patch
patch -R cpabe-0.11/policy_lang.c patches/cpabe-0.11@policy_lang.c.patch

# Configure and compile

cd pbc-0.5.14
./configure CFLAGS="-fPIC" CPPFLAGS="-fPIC"
make

cd ..
ROOT=$(pwd)

ls $ROOT/pbc-0.5.14/include
ls $ROOT/pbc-0.5.14/.libs/

cd libbswabe-0.9
./configure --with-pbc-include=$ROOT/pbc-0.5.14/include --with-pbc-lib=$ROOT/pbc-0.5.14/.libs/
make
