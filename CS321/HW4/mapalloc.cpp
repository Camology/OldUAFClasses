#include "mapalloc.h"

#include <iostream>
#include <map>
#include <string>
using std::map;
using std::size_t;

void * mapAlloc(size_t bt) {

    size = bt;
    void * address = mmap(
        nullptr,
        bt,
        PROT_READ | PROT_WRITE,
        MAP_SHARED | MAP_ANONYMOUS,
        -1,
        0);

    if (address == MAP_FAILED){
        return nullptr;
    }
    
  
    return address;

}
  
void mapFree(void * memPtr) {
    munmap(memPtr,size);
}



