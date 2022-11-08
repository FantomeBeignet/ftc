CC=/usr/bin/clang
LDFLAGS=-L/lib 
CPPFLAGS=-I/include
CFLAGS=-std=c99 -Wall -Wextra -Werror -Wno-error=unused-parameter -pedantic -fdiagnostics-color=always
CFLAGS+=$(CPPFLAGS) -O0 -g3 -fno-omit-frame-pointer -fno-optimize-sibling-calls -Qunused-arguments # -DNDEBUG
LDFLAGS+=-fsanitize=address

RUN_ENV=LSAN_OPTIONS=suppressions=lsan.ignore:print_suppressions=0:verbosity=1:log_threads=1 MallocNanoZone=0
#RUN_ENV=ASAN_OPTIONS=detect_leaks=1:symbolize=1
#RUN_ENV=

OBJS=src/main.o src/flags.o src/filesystem.o src/errors.o src/filters.o src/context.o
OUT=ftc

install: $(OBJS) $(OUT)
	$(CC) $(CFLAGS) $(OBJS) -c -o $(OUT)

src/.c.o:
	$(CC) -c $< -o $@

ftc: src/main.o
	$(CC) $(CFLAGS) $(OBJS) -o $(OUT)

clean:
	rm -rf $(OBJS) $(OUT)

.PHONY: clean
