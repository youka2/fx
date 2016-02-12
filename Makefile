# Copyright (c) 2016 youka \
 \
This software is provided 'as-is', without any express or implied \
warranty. In no event will the authors be held liable for any damages \
arising from the use of this software. \
 \
Permission is granted to anyone to use this software for any purpose, \
including commercial applications, and to alter it and redistribute it \
freely, subject to the following restrictions: \
 \
1. The origin of this software must not be misrepresented; you must not \
   claim that you wrote the original software. If you use this software \
   in a product, an acknowledgement in the product documentation would be \
   appreciated but is not required. \
2. Altered source versions must be plainly marked as such, and must not be \
   misrepresented as being the original software. \
3. This notice may not be removed or altered from any source distribution.

SRCS := $(shell ls *.c)
OBJS := $(SRCS:%.c=%.o)
O := $(shell basename `pwd`)

CC := cc
STRIP := strip

CFLAGS := $(shell sdl2-config --cflags) $(shell pkg-config --cflags glesv2)
CFLAGS += -nocpp -std=c89 -pedantic -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -Werror
CFLAGS += -O3 -pipe -m64 -march=native -mtune=native -ftree-vectorize -ffast-math -funroll-loops
CFLAGS += -DTITLE="\"Template\"" -DSW=800 -DSH=450

LDFLAGS := $(shell sdl2-config --libs)
LDFLAGS += $(shell pkg-config --libs gl) -lm

all: run
	@echo "Done."

clean:
	@for o in $(O) $(OBJS); do if [ -e $$o ]; then echo " CLEAN\t$$o"; rm $$o; fi; done
	@echo "Cleaned."

run: $(O)
	@echo " RUN\t$<"
	@./$<

$(O): $(OBJS)
	@echo " LINK\t$@"
	@$(CC) $(OBJS) -o $@ $(LDFLAGS)
	@echo " STRIP\t$@"
	@$(STRIP) -s $@

%.o: %.c $(shell ls *.h) Makefile
	@echo " CC\t$@"
	@$(CC) -c $< -o $@ $(CFLAGS)
