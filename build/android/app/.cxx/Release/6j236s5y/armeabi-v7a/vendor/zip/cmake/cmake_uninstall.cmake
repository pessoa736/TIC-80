# copied from https://gitlab.kitware.com/cmake/community/wikis/FAQ#can-i-do-make-uninstall-with-cmake
if(NOT EXISTS "/home/davi/Documentos/GitHub/TIC-80/build/android/app/.cxx/Release/6j236s5y/armeabi-v7a/install_manifest.txt")
  message(FATAL_ERROR "Cannot find install manifest: /home/davi/Documentos/GitHub/TIC-80/build/android/app/.cxx/Release/6j236s5y/armeabi-v7a/install_manifest.txt")
endif(NOT EXISTS "/home/davi/Documentos/GitHub/TIC-80/build/android/app/.cxx/Release/6j236s5y/armeabi-v7a/install_manifest.txt")

file(READ "/home/davi/Documentos/GitHub/TIC-80/build/android/app/.cxx/Release/6j236s5y/armeabi-v7a/install_manifest.txt" files)
string(REGEX REPLACE "\n" ";" files "${files}")
foreach(file ${files})
  message(STATUS "Uninstalling $ENV{DESTDIR}${file}")
  if(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    exec_program(
      "/home/davi/Android/Sdk/cmake/3.10.2.4988404/bin/cmake" ARGS "-E remove \"$ENV{DESTDIR}${file}\""
      OUTPUT_VARIABLE rm_out
      RETURN_VALUE rm_retval
      )
    if(NOT "${rm_retval}" STREQUAL 0)
      message(FATAL_ERROR "Problem when removing $ENV{DESTDIR}${file}")
    endif(NOT "${rm_retval}" STREQUAL 0)
  else(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    message(STATUS "File $ENV{DESTDIR}${file} does not exist.")
  endif(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
endforeach(file)

