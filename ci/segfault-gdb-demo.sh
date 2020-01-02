#!/bin/sh

set -ex

cat >testprg.c <<EOS
int main(int argc, char *argv[])
{
        char *a;
        a=(char *)0;
        a[1]="A";
        return 0;
}
EOS

cat testprg.c
# ${CC:-cc} -Wall -o testprg testprg.c
${CC:-cc} -g -o testprg testprg.c

gdb ./testprg

