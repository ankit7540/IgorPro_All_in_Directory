# IgorPro_All_in_Directory
A set of IgorPro procedures which run over all waves (whose name have a string followed by index ie. a number)

These procedures match a string against file name and iterate over the index (a number) and do some operation on the matched waves. All waves present in the folder which matching the common string are thus processed in a single run.

1. baseline_fit.ipf
Fit the baseline with a cubic polynomial where the region which is not included is governed by a mask wave. The baseline subtracted waves are generated in the same folder ( and or can be made to go into a new sub-folder).


