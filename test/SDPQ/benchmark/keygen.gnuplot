# Set output format and file
set terminal pngcairo size 800,600 enhanced font "Verdana,10"
set output 'benchmark_comparison.png'

# Title and labels
set title "Key Generation Benchmark" font ",14"
set xlabel "Number of Keys" font ",12"
set ylabel "Time (seconds)" font ",12"

# Style settings
set grid
set key outside top right
set style data linespoints

# Plot data
plot "keygen.txt" using 1:2 title "MLDSA44" with linespoints lc rgb "blue", \
     "keygen.txt" using 1:3 title "ES256" with linespoints lc rgb "red"
