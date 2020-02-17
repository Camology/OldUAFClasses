//Cameron K Titus
//Fall 2019 CS411
//Exhaustive search for building bridge to maximize tolls
//Worked on with @ChrisMcClure 

#include "build.h"
//checks for crossing bridges and multiple bridges from the same city,
//returns the maximum toll for given bridges subset
unsigned maximumToll(vector<Bridge> & subset, unsigned subset_size){
    unsigned toll = 0;
    for(unsigned i = 0; i < subset_size; i++){
        for(unsigned j = i+1; j < subset_size; j++){
            if((subset[i][0] <= subset[j][0] && subset[i][1] >= subset[j][1]) 
               || 
               (subset[i][0] >= subset[j][0] && subset[i][1] <= subset[j][1])){
                //  If A < A2 & B > B2 
                // or A > A2 & B < B2   There is a crossing
                // or if A = B or A2 = B2 there are multiple bridges from the same city   
                return 0;
            }
        }
        toll += subset[i][2];
    }
    return toll;
}

int build(int w, int e, const vector<Bridge> & bridges){    
    auto bridgesAmt = bridges.size(); // get the size of the bridges
    unsigned toll = 0;
    unsigned maxToll = 0;
    unsigned subsetSize = 0;
    
    vector<Bridge> subset(bridgesAmt); //size of subset is number of bridges given
    
    //this for loops creates all of the subsets of the given bridges
    //b0, b1, b0b1, b2, b0b2, b1b2, b0b1b2, etc
    for(int i = 1; i < pow(2,bridgesAmt); i++){ // from 0 up to 2^n
        for(int j = 0; j < bridgesAmt; j++){ // from 0 to n
            if(i&1<<j){ // if i and 1<<j have ones in the same position ie 0010 and 0010 
                subset[subsetSize] = bridges[j]; //add bridge j to the subset for calculating max toll
                subsetSize++;
            }
        }

        maxToll = std::max(maxToll, maximumToll(subset, subsetSize));
        subsetSize = 0; 
    }
    return maxToll;
}