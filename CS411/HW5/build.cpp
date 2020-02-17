//Cameron K Titus
//Fall 2019 CS411
//Top down dynamic programming for building bridges to maximize tolls
//Worked on with @ChrisMcClure 

#include "build.hpp"
using std::vector;
using std::sort;
using std::max;



bool cmp(vector<int> & b1, vector<int> & b2) {
    if (b1[0] == b2[0]) return (b1[1] < b2[1]);
    else return b1[0] < b2[0];
}

//Top down dynamic programming to calculate the maximum toll. There is a table of memo-ized values,
//indicated with a table entry != -1, and a max call to generate that toll to input into the the memo.
int recBridges(vector<Bridge> &bridges, int w, int e, vector<vector<int>> & table) {
    int toll = 0;
    if (table[w][e] != -1) return table[w][e];
    for (auto & b:bridges) {
        if(b[0] < w && b[1] < e) 
            toll = max(recBridges(bridges, b[0], b[1], table)+b[2], toll);
    }
    table[w][e] = toll;
    return toll;
}


int build(int w, int e, const vector<Bridge> & bridges){    
    auto table = vector<vector<int>>(w+1, vector<int>(e+1, -1));
    if (bridges.size() == 0) return 0;
    else if (bridges.size() == 1) return bridges[0][2];
    vector<Bridge> bridgeDupe (bridges);
    sort(bridgeDupe.begin(), bridgeDupe.end(), cmp);
    return recBridges(bridgeDupe, w, e, table);
}