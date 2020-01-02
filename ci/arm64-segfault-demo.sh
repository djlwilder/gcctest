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


cat >testprg.c <<EOS
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	struct stat st;
	fstat(0, &st);
	return 0;
}
EOS

cat testprg.c
${CC:-cc} -Wall -o testprg testprg.c

./testprg </dev/null

echo a >input
./testprg <input

echo b |./testprg

rm -f fifo
mkfifo fifo

./testprg <fifo &
echo c >fifo

sleep 1  # wait for the background process

exec 8<>fifo
echo d >fifo
ls -l /proc/self/fd
./testprg <&8

# This will segfault on arm64 and ppc64le, but not elsewhere:
echo e >fifo
rm fifo
./testprg <&8

