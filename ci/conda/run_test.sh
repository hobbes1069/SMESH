cd test
mkdir build
cd build

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*linux.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

declare ENABLE_NETGEN=true
if [[ ${HOST} =~ .*apple.* ]]; then
  ENABLE_NETGEN=false  # set to false if you don't want to build and test Netgen
fi

cmake -G "Ninja" \
      -D CMAKE_BUILD_TYPE:STRING="Release" \
      ${CMAKE_PLATFORM_FLAGS[@]} \
      -D CMAKE_INSTALL_PREFIX:FILEPATH=$PREFIX \
      -D CMAKE_PREFIX_PATH:FILEPATH=$PREFIX \
      -D ENABLE_NETGEN:BOOL=$ENABLE_NETGEN \
      ..

ninja install

cd ..
cd tests
./test_Catch
./test_StdMeshers
./test_MEFISTO2
if [[ ${ENABLE_NETGEN} ]]; then
  ./test_NETGENPlugin
fi

