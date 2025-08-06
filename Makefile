ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
TARGET := iphone:clang:16.5:15.0
else
TARGET := iphone:clang:14.5:11.0
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WhitePointModule
WhitePointModule_BUNDLE_EXTENSION = bundle
WhitePointModule_FILES = $(wildcard *.m)
WhitePointModule_FRAMEWORKS = MediaAccessibility Preferences
WhitePointModule_PRIVATE_FRAMEWORKS = ControlCenterUIKit AccessibilityUtilities
WhitePointModule_CFLAGS = -fobjc-arc
WhitePointModule_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk
