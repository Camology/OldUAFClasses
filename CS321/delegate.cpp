//Cameron K Titus
//HW2 CS321 

#include "sa2a.h"
#include <iostream>
using std::cin;
#include <thread>
using std::thread;
#include <vector>
using std::vector;
#include<string>
using std::string;
#include<mutex>
using std::mutex;

int counter=0;
vector<thread> workerPool(6);
vector<int> input, output, outputID;
mutex mutie;

void funkyThread() {
	while (!counter) {
		continue;
	}
	while(true) {
		mutie.lock();
		if (input.size() == 0 ) {
			mutie.unlock();
			return;
		}
		int temporary = input[input.size() -1];
		input.pop_back();
		mutie.unlock();
		int hashVal = sa2a(temporary);
		mutie.lock();
		outputID.push_back(temporary);
		output.push_back(hashVal);
		mutie.unlock();
	}

}


int main() {
	
	for (int i=0; i< 6; i++) {
		workerPool[i] = thread(funkyThread);
	}

	do {
		std::cout << "Enter a positive number to continue, 0 to end" << std::endl;
		string s;
		std::getline(cin, s);
		if (s.length() > 0)
			input.push_back(std::stoi(s));
	} while(input.back() > 0);
	input.pop_back();
	mutie.lock();
	counter = input.size();
	mutie.unlock();
	int printNum =0;
	while(true) {
		mutie.lock();
		if (output.size() == 0) {
			mutie.unlock();
			continue;
		}
		std::cout << "sa2a(" <<outputID[outputID.size()-1]<<") = " <<output[output.size()-1] <<std::endl;
		printNum++;
		outputID.pop_back();
		output.pop_back();
		if (counter == printNum){
			mutie.unlock();
			break;
		} 
		mutie.unlock();
	}

	for (int i=0; i< 6; i++) {
		workerPool[i].join();
	}

}
