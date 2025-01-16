# Set output format and file for the full plot
set terminal pngcairo size 800,600 enhanced font "Verdana,10"
set output 'full_sign_verify_comparison.png'

# Title and labels
set title "Signing and Verification Benchmark - Full" font ",14"
set xlabel "Payload Size (Fields)" font ",12"
set ylabel "Time (seconds)" font ",12"

# Style settings
set grid
set key outside top right
set style data linespoints

# Plot data for the full benchmark (SIGN_PQ, SIGN_ES256, VERIFY_PQ, VERIFY_ES256)
plot "sign_verify.txt" using 1:2 title "SIGN PQ" with linespoints lc rgb "blue", \
     "sign_verify.txt" using 1:3 title "SIGN ES256" with linespoints lc rgb "red", \
     "sign_verify.txt" using 1:4 title "VERIFY PQ" with linespoints lc rgb "green", \
     "sign_verify.txt" using 1:5 title "VERIFY ES256" with linespoints lc rgb "purple"

# Set output format and file for the sign plot
set output 'sign_comparison.png'

# Title and labels for sign plot
set title "Signing Benchmark" font ",14"
set xlabel "Payload Size (Fields)" font ",12"
set ylabel "Time (seconds)" font ",12"

# Plot data for sign benchmark (SIGN_PQ, SIGN_ES256)
plot "sign_verify.txt" using 1:2 title "SIGN PQ" with linespoints lc rgb "blue", \
     "sign_verify.txt" using 1:3 title "SIGN ES256" with linespoints lc rgb "red"

# Set output format and file for the verify plot
set output 'verify_comparison.png'

# Title and labels for verify plot
set title "Verification Benchmark" font ",14"
set xlabel "Payload Size (Fields)" font ",12"
set ylabel "Time (seconds)" font ",12"

# Plot data for verify benchmark (VERIFY_PQ, VERIFY_ES256)
plot "sign_verify.txt" using 1:4 title "VERIFY PQ" with linespoints lc rgb "green", \
     "sign_verify.txt" using 1:5 title "VERIFY ES256" with linespoints lc rgb "purple"

# Set output format and file for the sign and verify PQ plot
set output 'sign_verify_pq_comparison.png'

# Title and labels for sign and verify PQ plot
set title "Sign and Verify PQ Benchmark" font ",14"
set xlabel "Payload Size (Fields)" font ",12"
set ylabel "Time (seconds)" font ",12"

# Plot data for sign and verify PQ (SIGN_PQ, VERIFY_PQ)
plot "sign_verify.txt" using 1:2 title "SIGN PQ" with linespoints lc rgb "blue", \
     "sign_verify.txt" using 1:4 title "VERIFY PQ" with linespoints lc rgb "green"

# Set output format and file for the sign and verify ES256 plot
set output 'sign_verify_es256_comparison.png'

# Title and labels for sign and verify ES256 plot
set title "Sign and Verify ES256 Benchmark" font ",14"
set xlabel "Payload Size (Fields)" font ",12"
set ylabel "Time (seconds)" font ",12"

# Plot data for sign and verify ES256 (SIGN_ES256, VERIFY_ES256)
plot "sign_verify.txt" using 1:3 title "SIGN_ES256" with linespoints lc rgb "red", \
     "sign_verify.txt" using 1:5 title "VERIFY_ES256" with linespoints lc rgb "purple"
