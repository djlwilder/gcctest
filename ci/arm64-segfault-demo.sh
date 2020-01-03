#!/bin/bash

set -ex

# The real test prog
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
	unlink("./fifo");
	fstat(fd, &st);
	return 0;
}
EOS

# Test prog for testing gdb setup.
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
${CC:-cc} -Wall -g -o testprg testprg.c
ulimit -c unlimited

rm -f fifo
mkfifo fifo

# This will segfault on arm64 and ppc64le, but not elsewhere:
./testprg || RESULT=$?
if [ "$RESULT" != 139 ]; then
	echo "expected segfault and 139 exit but instead exited with $RESULT"
	exit 0
fi
for i in $(find ./ -maxdepth 1 -name 'core*' -print); do
	ls $i;
	gdb $(pwd)/testprg $i -ex "thread apply all bt" -ex "set pagination 0" -batch;
done
