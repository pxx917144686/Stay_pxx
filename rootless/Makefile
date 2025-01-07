# 包信息
PACKAGE_IDENTIFIER = com.dajiu.stay.pro
PACKAGE_NAME = stay
PACKAGE_VERSION = 0.1
PACKAGE_REVISION = 1
PACKAGE_ARCHITECTURE = iphoneos-arm
PACKAGE_SECTION = Tweaks
PACKAGE_DEPENDS = mobilesubstrate (>= 0.9.5000), firmware (>= 14.0)
PACKAGE_DESCRIPTION = stay for ios 测试一下～
PACKAGE_ICON = icon/icon.png

# 设置输出目录为项目目录（不使用 packages 目录）
export THEOS_PACKAGE_DIR = $(CURDIR)

# 设置安装路径为 /var/jb, 该路径适用于无根设备
THEOS_PACKAGE_INSTALL_PREFIX = /var/jb

# 设置构建目标平台，iphone:clang:latest:16.5 表示针对 iOS 16.5 版本编译
# 如果需要支持多个版本，可以设置为 iphone:clang:latest
TARGET = iphone:clang:latest:16.5

# 指定 Tweak 将注入的目标进程（注意此设置为无根插件的目标进程）
INSTALL_TARGET_PROCESSES = com.dajiu.stay.pro

# 引入 Theos 的通用设置
include $(THEOS)/makefiles/common.mk

# 设置 Tweak 名称
TWEAK_NAME = Stay

# 设置源代码文件（仅包含 Tweak.x）
Stay_FILES = Tweak.x

# 设置编译选项，启用 Objective-C ARC 管理内存
Stay_CFLAGS = -fobjc-arc

# 引入 Theos 的 Tweak 编译规则
include $(THEOS_MAKE_PATH)/tweak.mk

# 设置包信息
define PACKAGE
Package: $(PACKAGE_IDENTIFIER)
Name: $(PACKAGE_NAME)
Version: $(PACKAGE_VERSION)
Architecture: $(PACKAGE_ARCHITECTURE)
Maintainer: Nets
Author: pxx917144686
Section: $(PACKAGE_SECTION)
Depends: $(PACKAGE_DEPENDS)
Description: $(PACKAGE_DESCRIPTION)
Icon: $(PACKAGE_ICON)
endef
