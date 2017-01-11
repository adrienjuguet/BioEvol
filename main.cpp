#include <iostream>
#include "src/World.h"
#include "src/Common.h"
#include <chrono>

using namespace std;

int main() {
	
  auto begin = std::chrono::high_resolution_clock::now();
	
  printf("Init binding matrix\n");
  Common::init_binding_matrix(897685687);

  printf("Create World\n");
  World* world = new World(32, 32, 897986875);

  printf("Initialize environment\n");
  world->init_environment();

  bool test = false;
  if (test) {
    world->test_mutate();
  } else {
    printf("Initialize random population\n");
    world->random_population();

    printf("Run evolution\n");
    world->run_evolution();
  }
    auto end = std::chrono::high_resolution_clock::now();
	auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end-begin);
	printf("DUREE EXECUTION : %ld\r\n", duration.count());
}
