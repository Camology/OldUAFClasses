#ifndef MAPALLOC_H_INCLUDED
#define MAPALLOC_H

#include <stdio.h>
#include <cstddef> 
#include <sys/mman.h> 

void * mapAlloc(size_t);
void mapFree(void *);
size_t size;

#endif