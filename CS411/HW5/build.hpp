//build.h
//header file for build.cpp  CS411 HW2 Fall 2019
//Cameron K Titus Sept 2019

#ifndef BUILD_HPP
#define BUILD_HPP

#include "build.hpp"

#include<vector>
#include <algorithm>
using Bridge = std::vector<int>;

unsigned maximumToll(std::vector<Bridge> & subset, unsigned subset_size);
int build(int w, int e, const std::vector<Bridge> & bridges);



#endif //BUILD_HPP