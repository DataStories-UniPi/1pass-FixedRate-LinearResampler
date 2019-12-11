# 1-pass-fixed-rate-linear-resampler-in-Matlab-Octave
This is a template stand-alone code (no externals required) for a simple 1-pass fixed rate linear resampler. Specifically, the script can be used as-is or as base for a function, which take a series of pairs &lt;t,x> and a requested fixed resampling rate and it produces a new series of &lt;t',x'> using stepwise linear regressors.  The script includes a data sorting step against &lt;t>, which is not implemented here internally and can be removed if the input data are already expected to be sorted. In case of no sorting step here, the script is completely 1-pass, which means that all elements of the two input vectors (ref. points) are read only once for the entire resampling process. This is particularly useful when this implementation is to be applied directly to extremely large input files (e.g. columns in .csv) with only minimal memory usage for the calculations and only sequential read mode for speed.