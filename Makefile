# Local build using zmk dev container

ZMK_PATH := /workspaces/zmk
ZMK_APP_PATH := /workspaces/zmk/app
CONFIG_PATH := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

WEST_ARGS := --pristine

.ONESHELL:

bkd_xiao_ble: bkd_xiao_ble_left bkd_xiao_ble_right

bkd_xiao_ble_left: BOARD=seeeduino_xiao_ble
bkd_xiao_ble_left: build/bkd_xiao_ble_left.uf2

bkd_xiao_ble_right: BOARD=seeeduino_xiao_ble
bkd_xiao_ble_right: build/bkd_xiao_ble_right.uf2

build/%.uf2: FORCE
	#cd $(ZMK_PATH)
	mkdir -p build
	rm -f build/$*.uf2
	west build \
		$(WEST_ARGS) \
		-s $(ZMK_APP_PATH) \
		-d build/$* \
		-b $(BOARD) \
		-- \
		-DZMK_CONFIG="$(CONFIG_PATH)/config" \
		-DZMK_EXTRA_MODULES="$(CONFIG_PATH)" \
		-DSHIELD=$*
	cp build/$*/zephyr/zmk.uf2 build/$*.uf2

clean:
	rm -fr build/*.uf2

purge:
	rm -fr build

FORCE:
