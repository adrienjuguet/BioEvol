#define PRINT_TRACE
#ifdef PRINT_TRACE
#define PRINT(p) printf(p)
#else
#define PRINT(p)   
#endif

extern int NUM_THREADS_OMP; 
