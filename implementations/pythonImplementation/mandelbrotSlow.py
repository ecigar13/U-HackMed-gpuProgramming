import timeit
import numpy as np
import cProfile
from matplotlib import pyplot as plt
from matplotlib import colors


def mandelbrot_image(xmin, xmax, ymin, ymax, width=3, height=3, maxiter=80, cmap='hot'):
    dpi = 72
    img_width = dpi * width
    img_height = dpi * height
    x, y, z = mandelbrot_set(xmin, xmax, ymin, ymax, img_width, img_height, maxiter)

    fig, ax = plt.subplots(figsize=(width, height), dpi=72)
    ticks = np.arange(0, img_width, 3 * dpi)
    x_ticks = xmin + (xmax - xmin) * ticks / img_width
    plt.xticks(ticks, x_ticks)
    y_ticks = ymin + (ymax - ymin) * ticks / img_width
    plt.yticks(ticks, y_ticks)

    norm = colors.PowerNorm(0.3)
    ax.imshow(z.T, cmap=cmap, origin='lower', norm=norm)


def mandelbrot(z, maxiter):
    c = z
    for n in range(maxiter):
        if abs(z) > 2:
            return n
        z = z * z + c
    return maxiter


def mandelbrot_set(xmin, xmax, ymin, ymax, width, height, maxiter):
    r1 = np.linspace(xmin, xmax, width)
    r2 = np.linspace(ymin, ymax, height)
    return r1, r2, [mandelbrot(complex(r, i), maxiter) for r in r1 for i in r2]


cProfile.run('mandelbrot_set(-2.0, 0.5, -1.25, 1.25, 1000, 1000, 80)')
cProfile.run('mandelbrot_set(-0.74877,-0.74872,0.06505,0.06510,1000,1000,2048)')
