NAME=sketchybar
CFLAGS=-std=c99 -O3 -g -fPIC
INSTALL_DIR=$(HOME)/.local/share/sketchybar_lua

LUA_DIR=lua-5.5.0
CPPFLAGS=-I$(LUA_DIR)/src
LDFLAGS=-framework CoreFoundation

ifeq ($(shell uname),Darwin)
MODULE_LDFLAGS=-bundle -undefined dynamic_lookup
else
MODULE_LDFLAGS=-shared
endif

ifeq ($(shell uname -sm),Darwin arm64)
 ARCH= -arch arm64
else
 ARCH= -arch x86_64
endif

bin/$(NAME).so: src/$(NAME).c src/*.c | bin
	clang $(CFLAGS) $(MODULE_LDFLAGS) $(ARCH) $(CPPFLAGS) $^ $(LDFLAGS) -o bin/$(NAME).so

install: bin/$(NAME).so | $(INSTALL_DIR)
	mkdir -p $(INSTALL_DIR)
	mv bin/$(NAME).so $(INSTALL_DIR)

uninstall:
	rm -rf $(INSTALL_DIR)/$(NAME).so

clean:
	rm -rf bin
	cd $(LUA_DIR) && make clean

bin:
	mkdir bin

$(INSTALL_DIR):
	mkdir -p $(INSTALL_DIR)
