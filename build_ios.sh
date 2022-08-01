#!/bin/bash

XCODE_PATH=/Users/luoyongmeng/Documents/lym/Xcode.app/Contents
CRYPTO_FILENSME=libcrypto
SSL_FILENSME=libssl
function build_arm64(){
  make clean
  export CC=clang
  export CROSS_TOP=$XCODE_PATH/Developer/Platforms/iPhoneOS.platform/Developer
  export CROSS_SDK=iPhoneOS.sdk
  export PATH="$XCODE_PATH/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
  # 设置最小依赖版本
  export IPHONEOS_DEPLOYMENT_TARGET=8.0
  ./Configure ios64-cross no-shared no-asm --prefix=/usr/local/openssl-ios64
  make -j8
  echo `lipo -info ${CRYPTO_FILENSME}.a`
  if [[ -f ${CRYPTO_FILENSME}.a ]]; then
    echo '找到文件 '${CRYPTO_FILENSME}.a
    mv `pwd`/${CRYPTO_FILENSME}.a `pwd`/${CRYPTO_FILENSME}_arm64.a
  fi
  echo `lipo -info ${SSL_FILENSME}.a`
  if [[ -f ${SSL_FILENSME}.a ]]; then
    echo '找到文件 '${SSL_FILENSME}.a
    mv `pwd`/${SSL_FILENSME}.a `pwd`/${SSL_FILENSME}_arm64.a
  fi
}

function build_armv7(){
  make clean
  export CC="clang -arch armv7" 
 export CROSS_TOP=$XCODE_PATH/Developer/Platforms/iPhoneOS.platform/Developer
  export CROSS_SDK=iPhoneOS.sdk
  export PATH="$XCODE_PATH/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
  # 设置最小依赖版本
  export IPHONEOS_DEPLOYMENT_TARGET=8.0
 ./Configure iphoneos-cross no-shared no-asm --prefix=/usr/local/openssl-ios32
  make -j8
  echo `lipo -info ${CRYPTO_FILENSME}.a`
  if [[ -f ${CRYPTO_FILENSME}.a ]]; then
    echo '找到文件 armv7 '${CRYPTO_FILENSME}.a
    mv `pwd`/${CRYPTO_FILENSME}.a `pwd`/${CRYPTO_FILENSME}_armv7.a
  fi
  echo `lipo -info ${SSL_FILENSME}.a`
  if [[ -f ${SSL_FILENSME}.a ]]; then
    echo '找到文件 armv7 '${SSL_FILENSME}.a
    mv `pwd`/${SSL_FILENSME}.a `pwd`/${SSL_FILENSME}_armv7.a
  fi
}
build_armv7
build_arm64
lipo -create ${CRYPTO_FILENSME}_armv7.a ${CRYPTO_FILENSME}_arm64.a -output ${CRYPTO_FILENSME}.a
lipo -create ${SSL_FILENSME}_armv7.a ${SSL_FILENSME}_arm64.a -output ${SSL_FILENSME}.a
if [[ -f ${CRYPTO_FILENSME}_armv7.a ]]; then
    echo '找到文件 armv7 '${CRYPTO_FILENSME}_armv7.a
    rm -r ${CRYPTO_FILENSME}_armv7.a
fi
if [[ -f ${SSL_FILENSME}_armv7.a ]]; then
    echo '找到文件 armv7 '${SSL_FILENSME}_armv7.a
    rm -r ${SSL_FILENSME}_armv7.a
fi
if [[ -f ${CRYPTO_FILENSME}_arm64.a ]]; then
    echo '找到文件 armv7 '${CRYPTO_FILENSME}_arm64.a
    rm -r ${CRYPTO_FILENSME}_arm64.a
fi
if [[ -f ${SSL_FILENSME}_arm64.a ]]; then
    echo '找到文件 armv7 '${SSL_FILENSME}_arm64.a
    rm -r ${SSL_FILENSME}_arm64.a
fi
echo `lipo -info ${CRYPTO_FILENSME}.a`
echo `lipo -info ${SSL_FILENSME}.a`
zip -r GmSSL_iOS.zip *.a
make clean