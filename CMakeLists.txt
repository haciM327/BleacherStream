cmake_minimum_required(VERSION 3.16)

project(BleacherStream VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network WebSockets)

qt_standard_project_setup(REQUIRES 6.10)



# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appBleacherStream
    main.cpp
    client.cpp
    client.hpp
)

# Tell Qt to package OpenSSL libraries into the APK
if(ANDROID)
    include(FetchContent)
    # Qt 6.5+ automatically locates OpenSSL if installed via Qt Maintenance Tool
    set_property(TARGET appBleacherStream PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
        ${CMAKE_CURRENT_SOURCE_DIR}/android
    )
endif()

set_target_properties(appBleacherStream PROPERTIES
   QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

qt_add_qml_module(appBleacherStream
    URI BleacherStream
    QML_FILES
    main.qml
    QML_FILES title.qml
    QML_FILES host.qml
    QML_FILES guest.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appBleacherStream PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBleacherStream
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appBleacherStream
    PRIVATE Qt6::Quick Qt6::Network Qt6::WebSockets
)

install(TARGETS appBleacherStream
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
