include Make.rules.arm

VERSION=00.05-irvine-01

override LDFLAGS+=-lm -ldl -lgpio -L/opt/toolchain/toolchain-arm-linux/lib -Wl,-rpath -Wl,/opt/toolchain/toolchain-arm-linux/lib
override CFLAGS+=-Wall -std=gnu99 -DLINUX -DVERSION=\"$(VERSION)\" -I /opt/toolchain/toolchain-arm-linux/include

SRC=uvccapture.c v4l2uvc.c libjpeg_soft.c
OBJS=$(SRC:.c=.o)
EXECUTABLE=uvccapture
INSTALL_DEST=$(BIN_PATH)
STRIP?=strip

all: $(EXECUTABLE) yuv_decode
	$(STRIP) $(EXECUTABLE)

$(EXECUTABLE): $(OBJS)

yuv_decode: yuv_decode.c
	$(CC) $(CFLAGS) -I/opt/local/include -L/opt/local/lib $< -o $@ -ljpeg

install: $(EXECUTABLE)
	mkdir -p $(INSTALL_DEST)
	cp $(EXECUTABLE) yuv_decode $(INSTALL_DEST)
	cp yuv_decode $(LOCAL_BIN_PATH)

.PHONY: clean install

clean:
	rm -rf *.o $(EXECUTABLE) yuv_decode

