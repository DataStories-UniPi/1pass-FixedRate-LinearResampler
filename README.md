------------------------------------------------------------------------

PROJECT:        1pass Fixed Rate Linear Resampler
PACKAGE:        (signal processing / general tools)
FILE:           'resampl1.m'

PURPOSE:        Provide 1-pass fixed-rate linear resampling
VERSION:        1.0

STAGE:          BETA
UPDATED:        05-Jan-2017/10:00

HISTORY:        version 1.0: implemented core functionality (05-Jan-2017/10:00)

DESCRIPTION:    This is a template stand-alone code (no externals required) for a 
                simple 1-pass fixed rate linear resampler. Specifically, the script
                can be used as-is or as base for a function, which take a series of
                pairs <t,x> and a requested fixed resampling rate and it produces
                a new series of <t',x'> using stepwise linear regressors.
                The script includes a data sorting step against <t>, which is not
                implemented here internally and can be removed if the input data
                are already expected to be sorted. In case of no sorting step here,
                the script is completely 1-pass, which means that all elements of
                the two input vectors (ref. points) are read only once for the 
                entire resampling process. This is particularly useful when this
                implementation is to be applied directly to extremely large input 
                files (e.g. columns in .csv) with only minimal memory usage for
                the calculations and only sequential read mode for speed.

INPUT:          Tt : [Nx1] column vector with timestamps (e.g. secs)
                Xt : [Nx1] column vector with data series (ref. points)
                Trate : (scalar) arbitrary fixed-rate for resampling

OUTPUT:         Nr : (scalar) length of new column vectors
                D  : [Nr x2] two column vectors with resampled points
                        D(Nr,1) : new timestamps
                        D(Nr,2) : new data series

CONTRIBUTOR:    Harris Georgiou; Data Science Lab.

ACKNOWLEDGMENT: This work was partially supported by the European Union’s Horizon 2020 research and innovation programme under grant agreements No 687591 (DATACRON) and No 699299 (DART). 
LICENCE:        Creative Commons (CC-BY-SA) 4.0/I - http://creativecommons.org

-----------------------------------------------------------------------
