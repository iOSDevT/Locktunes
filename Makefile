THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222

SDKVERSION = 7.0

ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Locktunes
Locktunes_FILES = Tweak.xm
Locktunes_FRAMEWORKS = UIKit MediaPlayer

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += locktunes
include $(THEOS_MAKE_PATH)/aggregate.mk
