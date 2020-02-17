// merge_sort.cpp
// Glenn G. Chappell
// 9 Oct 2015
//
// For CS 411/611 Fall 2015
// Merge Sort using Iterators


#include <vector>
using std::vector;
#include <cstddef>
using std::size_t;
#include <algorithm>
using std::copy;
#include <iterator>
using std::distance;


template <typename FDIter>
size_t stableMerge(FDIter first, FDIter middle, FDIter last) {
    using Value = typename std::iterator_traits<FDIter>::value_type;
    size_t inversions = 0;

    vector<Value> buffer(distance(first, last));
                                // Buffer for temporary copy of data
    FDIter in1 = first;         // Read location in 1st half
    FDIter in2 = middle;        // Read location in 2nd half
    auto out = buffer.begin();  // Write location in buffer
    // ** auto! That *is* better than vector<Value>::iterator

    // Merge two sorted lists into a single list in buff.
    while (in1 != middle && in2 != last){
        if (*in2 < *in1) { // Must do comparison this way, to be stable.
            *out++ = *in2++;
            inversions += distance(in1, middle);
        }
        else
            *out++ = *in1++;
    }
    copy(in1, middle, out);
    copy(in2, last, out);

    // Copy buffer contents back to original sequence location.
    copy(buffer.begin(), buffer.end(), first);
    return inversions;
}


template <typename FDIter>
size_t mergeSort(FDIter first, FDIter last){
    // Compute size of sequence
    size_t size = distance(first, last);
    size_t inversions = 0;

    // BASE CASE
    if (size <= 1)
        return 0;

    // RECURSIVE CASE
    FDIter middle = next(first, size/2);

    // Recursively sort the two lists
    inversions += mergeSort(first, middle);
    inversions += mergeSort(middle, last);

    // And merge them
    inversions += stableMerge(first, middle, last);
    return inversions;
}

