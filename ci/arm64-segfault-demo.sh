#!/bin/sh

set -ex

# cat >testprg.c <<EOS
# #include <stdio.h>
# int main(int argc, char *argv[])
# {
# 	int c = 'z';
# 	c = getc(stdin);
# 	if (c == EOF)
# 		printf("EOF!\n");
# 	else
# 		printf("got '%c' (0x%x)\n", c, c);
# 	return 0;
# }
# EOS


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
	fstat(fd, &st);
	unlink("./fifo");
	fstat(fd, &st);
	return 0;
}
EOS

cat testprg.c
${CC:-cc} -Wall -g -o testprg testprg.c

# ./testprg </dev/null
# echo a >input
# ./testprg <input
# echo b |./testprg

rm -f fifo
mkfifo fifo
# echo e > ./fifo

# exec 8<>fifo
# echo d >fifo
# ls -l /proc/self/fd
# ./testprg <&8

# This will segfault on arm64 and ppc64le, but not elsewhere:
ls -l /proc/self/fd
./testprg

