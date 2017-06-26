# Super-Resolution of Multispectral Multiresolution Images from a Single Sensor

## Authors
- [Charis Lanaras](mailto:charis.lanaras@geod.baug.ethz.ch)
- Jose Bioucas Dias 

Copyright 2017: ETH Zurich, Universidade de Lisboa 

## Changes
0.1 First release.

## Important

If you use this software you should cite the following in any resulting
publication:

    [1] Super-Resolution of Multispectral Multiresolution Images from a Single Sensor
        C. Lanaras, J. Bioucas-Dias, E. Baltsavias, K. Schindler
        In CVPRW, Honolulu, USA, July 2017

## About

This is the authors' implementation of [1].

The code is implemented in MATLAB:
-  apexSample.mat            - a sample of an APEX image simulated to the Sentinel-2 responses
                                available at (http://www.apex-esa.org/content/free-data-cubes)
-  ms_fusion_apex.m          - a demo script that executes SupReME
-  ./functions               - all necessary functions
-  LICENSE                   - GPL license of the code
-  README                    - this file


## Notes

The co-registration of the different resolution channels is treated as with
real Sentinel-2 images.


