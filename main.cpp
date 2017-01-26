#include <iostream>
#include "src/World.h"
#include "src/Common.h"
#include <chrono>
#include "src/main.h"

int NUM_THREADS_OMP = 1;

using namespace std;

int main(int argc, char *argv[]) 
{
  int h=32, w=32;
  if(argc == 2) 
  {
    NUM_THREADS_OMP = atoi(argv[1]);
  }
  else if(argc == 3)
  {
    NUM_THREADS_OMP = atoi(argv[1]);
    h = atoi(argv[2]);
    w = atoi(argv[2]);
  }
  else if(argc == 4)
  {
    NUM_THREADS_OMP = atoi(argv[1]);
    h = atoi(argv[2]);
    w = atoi(argv[3]);
  }
  else if(argc == 1){}
  else 
  {
    printf("Arguments invalides : ./pdc_evol_model nb_threads world_height world_width\r\n");
    cout << "nb_threads = " << NUM_THREADS_OMP <<endl;
    cout << "world_height = " << h <<endl;
    cout << "vorld_width = " << w <<endl;
    return -1;
  }
  auto begin = std::chrono::high_resolution_clock::now();

  PRINT("Init binding matrix\n");
  Common::init_binding_matrix(897685687);

  PRINT("Create World\n");
  World* world = new World(w, h, 897986875);

  PRINT("Initialize environment\n");
  world->init_environment();

  bool test = false;
  if (test) {
    world->test_mutate();
  } else {
    PRINT("Initialize random population\n");
    world->random_population();

    PRINT("Run evolution\n");
    world->run_evolution();
  }
  auto end = std::chrono::high_resolution_clock::now();
  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end-begin);
  #ifdef PRINT_TRACE
  printf("DUREE EXECUTION : %ld\r\n", duration.count());
  #else
  std::cout<<duration.count();
  #endif
}
