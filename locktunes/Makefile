SDKVERSION = 7.0
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = Locktunes
Locktunes_FILES = Locktunes.mm
Locktunes_INSTALL_PATH = /Library/PreferenceBundles
Locktunes_FRAMEWORKS = UIKit
Locktunes_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Locktunes.plist$(ECHO_END)
