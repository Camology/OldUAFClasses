/////
#include <iostream>
#include <string>
#define CATCH_CONFIG_MAIN
#include "catch.hpp"

int pop(std::string &s) {
	int found = s.find_first_of(",");
	if (found > 0){
		std::string ns = s.substr(0,found);
		s=s.substr(s.find_first_of(ns)+ns.length()+1, std::string::npos);
		std::cout << s << std::endl;
		return std::stoi(ns);
	}
	int value = std::stoi(s);
	s = "";
	return value;
}

int sum(std::string s){
	int sum=0;
    while(!s.empty()) {
        sum += pop(s);
    }
    return sum; 
}


TEST_CASE("Zero test"){
	REQUIRE(sum("") == 0);
}    
TEST_CASE("Value test"){
    REQUIRE(sum("1") == 1);
    REQUIRE(sum("12") == 12);
    REQUIRE(sum("999") == 999);
}

TEST_CASE("Sum of 2 test"){
	REQUIRE(sum("1,2")==3);
}
