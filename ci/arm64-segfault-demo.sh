#!/bin/sh

set -ex

# cat > ~root/.gdbinit <<EOS
# set pagination off
# set logging file gdb.output
# set logging on
# run
# bt
# disassemble main
# info registers
# quit
# EOS


cat >testprg.c <<EOS
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	struct stat st;
	int fd;

	fd=open("./fifo",O_RDWR);
	// The fstat segfaults if the named pipe has been unlinked.
	# unlink("./fifo");
	fstat(fd, &st);
	return 0;
}
EOS

cat testprg.c
${CC:-cc} -Wall -g -o testprg testprg.c

rm -f fifo
mkfifo fifo

# This will segfault on arm64 and ppc64le, but not elsewhere:
ls -l /proc/self/fd
./testprg

