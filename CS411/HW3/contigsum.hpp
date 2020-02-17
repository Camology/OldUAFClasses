//Cameron K Titus
//CS411 HW3 Fall 2019 UAF
//This computes the greatest contiguous sum (GCS) of a given set of numbers.

#ifndef CONTIGSUM_HPP
#define CONTIGSUM_HPP
#include <algorithm>
#include <numeric>

// template<typename RAIter>int contigSum(RAIter first, RAIter last);

// A - Greatest Contiguous Sum of the Sequence
// B - Great possible sum of the subsequence that includes the first
//     value of the sequence or zero if all such sums are negative
// C - Same as above, but with the last value of the sequence instead of the first
// D - Sum of the entire sequence  


// A is the Max of : (A1, A2, C1 + 2B)


struct GCStruct {
    int gcs, lGCS, rGCS, sum = 0;
    //  A    B     C     D
    GCStruct() = default;
    GCStruct(int a, int b, int c, int d):gcs(a), lGCS(b), rGCS(c), sum(d) {}
};

template<typename RAIter>GCStruct contigSumRecursive(RAIter first, RAIter last, std::size_t size) {
    if (size < 2) return GCStruct(*first, *first, *(last-1), std::accumulate(first,last,0));
    //be careful with std::accumulate, see this for examples:
    //https://www.fluentcpp.com/2017/10/17/stdaccumulate-your-knowledge-on-algorithms/
    else {
        auto middle = std::next(first, size/2);
        //middle is first + size/2 (integer division)
        auto left = contigSumRecursive(first,middle, std::distance(first,middle));
        //recurse on the first to middle for the left half
        auto right = contigSumRecursive(middle,last, std::distance(middle, last));
        //recurse on the middle to last for right half
        return GCStruct (
            std::max({left.rGCS+right.lGCS, left.gcs, right.gcs}),
            //gcs is either 1C+2B, 1A, or 2A
            std::max({left.lGCS, left.sum + right.lGCS}),
            //lGCS is either 1B or 1D+2B
            std::max({left.rGCS + right.sum, right.rGCS}),
            //rGCS is either 1C + 2D or 2C
            left.sum+right.sum
            //sum is always 1D + 2D
        
        );
    }
}

template<typename RAIter>int contigSum(RAIter first, RAIter last) {
    size_t size = std::distance(first, last);
    //distance is the number of increments to get from first to last
    (size < 1) ? 0 : std::max({contigSumRecursive(first,last, size).gcs, 0});
     // if size is < 1 return 0 else return max of gcs and 0
}
#endif