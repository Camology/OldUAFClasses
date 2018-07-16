// Cameron K Titus
// 3/27/2018
// randacc.cpp
// CS321 Assignment 4 B





#include <iostream>
#include <cstddef>
using std::size_t;
#include <string>
#include <sstream>
#include <unistd.h>
// for _exit, write, close
#include <sys/mman.h>
// for mmap, munmap, related constants
#include <fcntl.h>
// for open, related constants
#include <sys/types.h>
// For ssize_t
#include<sys/stat.h> 


void wait_exit(int code) {
    std::cout << "Press ENTER to quit ";
    while (std::cin.get() != '\n') ;
    _exit(code);
}

//closeThis
//Pre:none
//Post:Closes a file discriptor.
void closeThis(int fd) {
    std::cout << "Closing File!!!" << std::endl;
    int close_failure = close(fd);
    if (close_failure) {
        std::cout << "Close Failed" << std::endl;
        wait_exit(1);
    }
    else {
        std::cout << "Closed the File" << std::endl;
    }
}

//getFileSize
//Pre::none
//Post::Returns the filesize of the passed filename.
off_t getFileSize(const std::string & fileName){
    struct stat st;
    
    if (stat(fileName.c_str(), &st) == 0){
        return st.st_size;
    }

    return -1;

}

//readFile
//Pre::none
//Post::Reads the input given at a specific
//record numberber
void readFile(std::string & filePath) {
    int fd = open(
        filePath.c_str(),
        O_CREAT|O_RDONLY,
        0644);
        if (fd == -1) {
            std::cout << "Could not open file" << std::endl;
            _exit(1);
        }

        int number;
        std::string input;
        std::cout << "Enter a record (0 - 99)" << std::endl;
        std::cin >> number;
        void *address = mmap(
            nullptr,
            getFileSize(filePath),
            PROT_READ,MAP_SHARED,
            fd,
            0);
        if(address == MAP_FAILED){
		std::cout << "Failed to get memory" << std::endl;
		closeThis(fd);
		wait_exit(1);
        }

        char *value = (char*)address;
        std::cout << "The value at " << number << " is " << value[number] << std::endl;
      

        int munmap_failure = munmap(
            address, getFileSize(filePath));

        if (munmap_failure) {
            std::cout << "Failed to deallocate" << std::endl;
            closeThis(fd);
            wait_exit(1);
        }

        closeThis(fd);
}

void writeFile(const std::string & fileName) {
    const int SIZE = 20;
    ssize_t dummy;
    //Open the file
    std::cout << "Opening file: " << fileName << std::endl;
    

    int fd = open(
        fileName.c_str(),        // Filename
        O_RDWR | O_CREAT | O_TRUNC,
        0644);

    if (fd == -1){
        std::cout << "Could not open File" << std::endl;
        wait_exit(1);
    }

    std::cout << "File : " << fileName << " succeded" << std::endl;
    
    // Write initial contents of file
    std::cout << "Initializing file with 'write' system call" << std::endl;
    for (size_t i = 0; i < SIZE+10; ++i)
    {
        dummy = write(fd, "-", 1);
    }
    dummy = write(fd, "\n", 1);
    std::cout << std::endl;

    // Memory map the file
    std::cout << "Calling mmap (named file)" << std::endl;
    void * address = mmap(
        nullptr,                 // Requested addressess (no request)
        SIZE,                    // How much memory
        PROT_READ | PROT_WRITE,  // Access flags
        MAP_SHARED,              // File & sharing flags
        fd,                      // File descriptor
        0);                      // Byte offset in file
    // Error check for mmap
    
    if (address == MAP_FAILED)
    {
        std::cout << "- mmap FAILED" << std::endl;
        std::cout << std::endl;
        closeThis(fd);
        std::cout << std::endl;
        wait_exit(1);
    }
    std::cout << "- mmap succeeded" << std::endl;
    std::cout << std::endl;

    int number;
    int newNumber;
    std::cout << "Enter a Record to modify (0 - 99)" <<std::endl;
    std::cin >> number;
    std::cout << "Enter an Integer to put in" <<std::endl;
    std::cin >> newNumber;
    //TODO WRITE TO THE FILE

}




int main(){

    std::string fileName = "testing.txt";
    int n;
    std::string input;
    std::string filePath = "testing.txt";
    std::cout << "Choose one of the following" << std::endl;
    std::cout << "1: Read " << std::endl;
    std::cout << "2: Write " << std::endl;
    std::cout << "3: Exit " << std::endl;


    getline(std::cin, input);
    std::istringstream iss(input);
    iss >> n;

    switch(n){
        case 1:readFile(fileName);
        break;
        case 2:writeFile(fileName);
        break;
        case 3:wait_exit(1);
        break;
        default : std::cout << "You didn't choose an input" << std::endl;
        break;
    }
    
}