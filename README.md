# U-HackMed-gpuProgramming

The bottleneck of moving data to GPU and back means I should rely on CPU in certain areas and GPU in certain areas, not always GPU. So far I am using Numba and Numpy.

A wild idea is to divide the space into squares and calculate association based on what's in the squares. Then implement parallelization on those squares.

Next step: learn about Delaunay triangulation, Bowyer-Watson algo and how they work. I don't know anything now. Useful links:
 - Delaunay: https://en.wikibooks.org/wiki/Trigonometry/For_Enthusiasts/Delaunay_triangulation
 - Delaunay: https://en.wikipedia.org/wiki/Delaunay_triangulation
 - Bowyer-Watson: https://en.wikipedia.org/wiki/Bowyer%E2%80%93Watson_algorithm


Very useful websites:
 - Python list comprehension: https://www.ibm.com/developerworks/community/blogs/jfp/entry/Python_List_Comprehensions?lang=en_us
 - Speed comparison on LU factorization: https://www.ibm.com/developerworks/community/blogs/jfp/entry/A_Comparison_Of_C_Julia_Python_Numba_Cython_Scipy_and_BLAS_on_LU_Factorization?lang=en_us
 - Speed comparison on Mandelbrodt: https://www.ibm.com/developerworks/community/blogs/jfp/entry/How_To_Compute_Mandelbrodt_Set_Quickly?lang=en

Book:
    Programming with massively parallel processors, 3rd edition by David B. Kirk, Wen-mei W. Hwu

Sincerely,

-paniz
