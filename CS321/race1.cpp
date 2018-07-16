// race1.cpp
// Glenn G. Chappell
// 2 Feb 2018
//
// For CS 321 Spring 2018
// Race Condition

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <thread>
using std::thread;
#include <vector>
using std::vector;
#include <cstdlib>
using std::exit;


// *********************************************************************
// * NOTE: This code is written with the aim of demonstrating a race   *
// * condition. Please do not imitate it.                              *
// *********************************************************************


const int NUMTHREADS = 5;  // Number of worker threads to spawn
int count;                 // Counter. Starts at 0. We want to increment
                           //  this until it equals endvalue.
const int endvalue = 4;    // The hoped-for final value for count


// run
// Run function for spawned threads
// Increment global count if it is less than endvalue.
// (Sadly, not thread-safe.)
void run(int n)
{
    int getcount = count;
    if (getcount < endvalue)
    {
        cout << "Worker " << n << ": count is low - incrementing"
             << endl;
        ++getcount;
        count = getcount;
    }
    else
    {
        cout << "Worker " << n << ": count is high - NOT incrementing"
             << endl;
    }
}


// Main program
// Spawn a number of threads, each runnning function "run". Join all and
// print result.
int main()
{
    count = 0;

    cout << "Master: --------------------------------------------------"
         << endl;
    cout << "Master: START; count = " << count << endl;
    cout << "Master: Spawn " << NUMTHREADS
         << " threads & join all of them"
         << endl;

    // Vector of thread objects, not yet holding actual threads
    vector<thread> ts(NUMTHREADS);

    // Spawn all threads
    for (int i = 0; i < NUMTHREADS; ++i)
    {
        try
        {
            ts[i] = thread(run, i);
        }
        catch(...)
        {
            cout << endl;
            cout << "ERROR: It appears that we can only spawn "
                 << i << " threads on this system." << endl;
            cout << "  Try reducing NUMTHREADS to " << i
                 << " and recompiling." << endl;
            exit(1);
        }
    }

    // Join all spawned threads
    for (int i = 0; i < NUMTHREADS; ++i)
    {
        ts[i].join();
    }

    cout << "Master: END; count = " << count << endl;
    cout << "Master: (We want the above to be " << endvalue << ")"
         << endl;
    cout << endl;

    // Wait for user
    cout << "Press ENTER to quit ";
    while (cin.get() != '\n') ;

    return 0;
}

