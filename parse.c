#include "config.h"
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "spl_internal.h"

int
main(int argc, char **argv)
{
    //char *filename = "spl_code/simple_aggregate.spl";
    char *filename = "spl_code/simple_barrier.spl";
    //char *filename = "spl_code/simple_split.spl";
    //char *filename = "spl_code/trivial.spl";
    struct stat buf;
    char *buffer;
    int fd, total_read;

    if (argc > 1) {
	filename = argv[1];
    }
    /* the parser is setup to parse from memory, so read the file to memory */
    if (stat(filename, &buf) != 0) {
	fprintf(stderr, "NO file %s\n", filename);
	exit(1);
    }
    buffer = malloc(buf.st_size);
    fd = open(filename, O_RDONLY, 0);
    total_read = 0;
    while (total_read < buf.st_size) {
	int n_read;
	n_read = read(fd, buffer + total_read, buf.st_size - total_read);
	total_read += n_read;
    }

    spl_code_gen(buffer, NULL);
}
