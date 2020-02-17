//build.h
//header file for build.cpp  CS411 HW2 Fall 2019
//Cameron K Titus Sept 2019

#ifndef BUILD_H
#define BUILD_H

#include "build.h"

#include<vector>
using std::vector;
using Bridge = vector<int>;
#include <math.h>
#include <algorithm>

unsigned maximumToll(vector<Bridge> & subset, unsigned subset_size);
int build(int w, int e, const vector<Bridge> & bridges);



#endif //BUILD_H