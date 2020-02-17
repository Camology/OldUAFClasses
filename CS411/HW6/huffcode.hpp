// huffcode.hpp  UNFINISHED
// Glenn G. Chappell
// 29 Nov 2015
//
// For CS 411/611 Fall 2015
// Assignment 6, Exercise A
// Header for class HuffCode
//
// Modified 11/22/17
// Chris Hartman
// For CS 411 Fall 2017
//
// Modified 12/7/2019
// Cameron K Titus
// For CS 411 Fall 2019

#ifndef FILE_HUFFCODE_H_INCLUDED
#define FILE_HUFFCODE_H_INCLUDED

#include <string>
using std::string;
#include <unordered_map>
using std::unordered_map;
#include <memory>
using std::shared_ptr;
using std::make_shared;
#include <sstream>
using std::ostringstream;
#include <queue>
using std::priority_queue;
#include <vector>
using std::vector;



struct Leaf {
	Leaf() {}
	Leaf(char key, int weight) : _key(key), _weight(weight) {}
	Leaf(const shared_ptr<Leaf> & lhs, const shared_ptr<Leaf> & rhs, int weight) : 
		_leftLeaf(lhs),
		_rightLeaf(rhs),
		_key(0),
		_weight(weight)
	{}

	shared_ptr<Leaf> _leftLeaf,_rightLeaf = nullptr;
	char _key = 0;
	int _weight = 0;
};

// Class HuffCode
// Encoding & decoding using a Huffman code
class HuffCode {

// ***** HuffCode: ctors, dctor, op= *****
public:

    // Compiler-generated default ctor, copy ctor, copy =, dctor used

// ***** HuffCode: general public functions *****
public:

    void setWeights(const std::unordered_map<char, int> & theweights);
    std::string encode(const std::string & text) const;
    std::string decode(const std::string & codestr) const;
    void mapCodes(Leaf & Leaf, string code);


// ***** HuffCode: data members *****
private:
    Leaf _root;
	unordered_map<char, string> _encodeMap;

};  // End class HuffCode


#endif //#ifndef FILE_HUFFCODE_H_INCLUDED

