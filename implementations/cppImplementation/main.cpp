#include <stdio.h>


    int
    mandelbrot (double creal, double cimag, int maxiter) {
      double real = creal, imag = cimag;
      int n;
      for(n = 0; n < maxiter; ++n) {
        double real2 = real*real;
        double imag2 = imag*imag;
        if (real2 + imag2 > 4.0)
          return n;
        imag = 2* real*imag + cimag;
        real = real2 - imag2 + creal;
      }
      return 0;
    }



    int*
    mandelbrot_set (double xmin, double xmax,
            double ymin, double ymax,
            int width, int height,
            int maxiter,
            int *output) {

      int i,j;

      double *xlin = (double *) malloc (width*sizeof(double));
      double *ylin = (double *) malloc (width*sizeof(double));

      double    dx = (xmax - xmin)/width;
      double    dy = (ymax - ymin)/height;

      for (i = 0; i < width; i++)
        xlin[i] = xmin + i * dx;
      for (j = 0; j < height; j++)
        ylin[j] = ymin + j * dy;


      for (i = 0; i < width; i++) {
        for (j = 0; j < height; j++) {
          output[i*width + j] = mandelbrot(xlin[i], ylin[j], maxiter);
        }
      }

      free(xlin);
      free(ylin);

      return output;
    }
