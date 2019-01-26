# Results

## Pre-patch

```
Generating schema

---
Generating 1000 row(s) of data
Generating index 100 time(s)

min  = 0.000904
max  = 0.001258
mean = 0.0010171600000000002
p50  = 0.0010125
p75  = 0.00107325
p95  = 0.0011212

Truncating data
---
Generating 10000 row(s) of data
Generating index 100 time(s)

min  = 0.005776
max  = 0.030469
mean = 0.0065037300000000044
p50  = 0.0060090000000000005
p75  = 0.0061075
p95  = 0.00625615

Truncating data
---
Generating 100000 row(s) of data
Generating index 100 time(s)

min  = 0.066721
max  = 0.093911
mean = 0.07214983000000001
p50  = 0.0681155
p75  = 0.0686665
p95  = 0.09141355

Truncating data
---
Generating 1000000 row(s) of data
Generating index 100 time(s)

min  = 0.749199
max  = 0.851395
mean = 0.77258445
p50  = 0.767247
p75  = 0.7773352499999999
p95  = 0.8071030499999999

Truncating data
---
Generating 10000000 row(s) of data
Generating index 100 time(s)

min  = 7.841454
max  = 9.266041
mean = 7.936806570000003
p50  = 7.907461
p75  = 7.9465727500000005
p95  = 8.064655299999998

Truncating data
```

## Post-patch

```
Generating schema

---
Generating 1000 row(s) of data
Generating index 100 time(s)

min  = 0.000814
max  = 0.001373
mean = 0.0009348
p50  = 0.000924
p75  = 0.0009885
p95  = 0.0010313

Truncating data
---
Generating 10000 row(s) of data
Generating index 100 time(s)

min  = 0.004419
max  = 0.029986
mean = 0.00520178
p50  = 0.0046965
p75  = 0.004796
p95  = 0.0049716

Truncating data
---
Generating 100000 row(s) of data
Generating index 100 time(s)

min  = 0.048839
max  = 0.079167
mean = 0.054745669999999996
p50  = 0.050678
p75  = 0.051969
p95  = 0.07486369999999999

Truncating data
---
Generating 1000000 row(s) of data
Generating index 100 time(s)

min  = 0.55005
max  = 0.645045
mean = 0.5750675600000001      # ~25.6% improvement
p50  = 0.5659475
p75  = 0.5833285
p95  = 0.61738755              # ~23.5% improvement

Truncating data
---
Generating 10000000 row(s) of data
Generating index 100 time(s)

min  = 5.766131
max  = 7.296124
mean = 5.8546793799999985      # ~26.2% improvement
p50  = 5.819115
p75  = 5.8598875
p95  = 5.9931014000000005      # ~25.7% improvement

Truncating data
```
