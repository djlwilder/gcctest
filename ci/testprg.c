#include <stdio.h>
int main(int argc, char *argv[])
{
	int c = 'z';
	c = getc(stdin);
	if (c == EOF)
		printf("EOF!\n");
	else
		printf("got '%c' (0x%x)\n", c, c);
	return 0;
}
