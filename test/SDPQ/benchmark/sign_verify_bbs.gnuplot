# Set output format and file for the full plot
set terminal pngcairo size 800,600 enhanced font "Verdana,10"
set output 'bbs_sign_verify_comparison.png'

# Title and labels
set title "Signing and Verification Benchmark - Full" font ",14"
set xlabel "Credentials" font ",12"
set ylabel "Seconds" font ",12"

# Style settings
set grid
set key left nobox
set style data points
set autoscale

# Manually adjust y-axis range for better clarity
set yrange [0.0005:0.65]  # Adjust this to ensure proper space for all values

# Plot data for the full benchmark (SIGN_PQ, SIGN_BBS, VERIFY_PQ, VERIFY_BBS)
plot for [col=2:5] "sign_verify_bbs.txt" using 0:col:xticlabels(1) with lines linetype 8 dashtype col title columnheader
