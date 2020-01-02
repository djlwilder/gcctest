#!/bin/sh

set -ex

cat >testprg.c <<EOS
int main(int argc, char *argv[])
{

        char b;
        char *a;
	b=a[10];
	return 0;
}
EOS

cat testprg.c
# ${CC:-cc} -Wall -o testprg testprg.c
${CC:-cc} -o testprg testprg.c

gdb ./testprg

