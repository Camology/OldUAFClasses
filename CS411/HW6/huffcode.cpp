// huffcode.cpp
// Glenn G. Chappell
// 29 Nov 2015
//
// For CS 411/611 Fall 2015
// Assignment 6, Exercise A
// Source for class HuffCode
//
// Modified 11/22/17
// Chris Hartman
// For CS 411 Fall 2017
//
// Modified 12/7/2019
// Cameron K Titus
// For CS 411 Fall 2019

#include "huffcode.hpp"  // for class HuffCode declaration



void HuffCode::setWeights(const unordered_map<char, int> & theweights) {
    
    if (theweights.empty()) { return; }
    auto comparator = [&](auto lhs, auto rhs) {return lhs._weight > rhs._weight;};
	priority_queue<Leaf, vector<Leaf>, decltype(comparator)> weightsQueue(comparator);

	for(auto & i : theweights) {weightsQueue.push(Leaf(i.first, i.second));}

	while(weightsQueue.size() != 1){
        auto left = weightsQueue.top();
		weightsQueue.pop();

        auto right = weightsQueue.top();
        weightsQueue.pop();

        Leaf newLeaf(make_shared<Leaf>(left), make_shared<Leaf>(right), left._weight + right._weight);
		weightsQueue.push(newLeaf);
	}
    _root = weightsQueue.top();
    weightsQueue.pop();

	mapCodes(_root, "");
}


string HuffCode::encode(const string & text) const {
    string encoding;
    for(auto letter:text) { encoding+=_encodeMap.find(letter)->second;}
    return encoding;
}


string HuffCode::decode(const string & codeStr) const {
    
	auto currentLeaf = _root;
	auto codeStrPos = codeStr.begin();
    ostringstream text;

	while(codeStrPos != codeStr.end()) {
		if((*codeStrPos) == '0'){
			currentLeaf = *currentLeaf._leftLeaf;
			codeStrPos++;
		} 
        else if ((*codeStrPos) == '1') {
			currentLeaf = *currentLeaf._rightLeaf;
			codeStrPos++;
		}
		if( currentLeaf._key != 0 ) {
			text << currentLeaf._key;
			currentLeaf = _root;
			continue;
		}

	}
	return text.str();
}

void HuffCode::mapCodes(Leaf & Leaf, string code) {
	if (Leaf._weight > 0) {
        if(Leaf._key == 0 ) {
            mapCodes( *(Leaf._leftLeaf), code + "0");
            mapCodes( *(Leaf._rightLeaf), code + "1");
        } 
        else {
            _encodeMap.insert({ Leaf._key, code });
        }
    }
}

