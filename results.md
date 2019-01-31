# Results

## Pre-patch

```
Generating schema

---
Generating 1000 row(s) of data
Sorting 100 time(s)

min  = 0.000424
max  = 0.001127
mean = 0.0004661199999999999
p50  = 0.000454
p75  = 0.0004725
p95  = 0.00051235

Truncating data
---
Generating 10000 row(s) of data
Sorting 100 time(s)

min  = 0.004068
max  = 0.004761
mean = 0.004209499999999999
p50  = 0.004191
p75  = 0.00426075
p95  = 0.0043713499999999995

Truncating data
---
Generating 100000 row(s) of data
Sorting 100 time(s)

min  = 0.051739
max  = 0.059036
mean = 0.05313033000000002
p50  = 0.052864
p75  = 0.053511750000000004
p95  = 0.05483335

Truncating data
---
Generating 1000000 row(s) of data
Sorting 100 time(s)

min  = 0.79334
max  = 0.871573
mean = 0.8177914500000003
p50  = 0.8123075
p75  = 0.8276494999999999
p95  = 0.84973

Truncating data
---
Generating 10000000 row(s) of data
Sorting 100 time(s)

min  = 11.690582
max  = 12.176468
mean = 11.876579259999998
p50  = 11.884907
p75  = 11.973726749999999
p95  = 12.0734449

Truncating data
```

## Post-patch

```
Generating schema

---
Generating 1000 row(s) of data
Sorting 100 time(s)

min  = 0.00029
max  = 0.000895
mean = 0.0003126500000000002
p50  = 0.000302
p75  = 0.000304
p95  = 0.00033715

Truncating data
---
Generating 10000 row(s) of data
Sorting 100 time(s)

min  = 0.002417
max  = 0.003123
mean = 0.002479150000000002
p50  = 0.002452
p75  = 0.002485
p95  = 0.0025877

Truncating data
---
Generating 100000 row(s) of data
Sorting 100 time(s)

min  = 0.028864
max  = 0.034043
mean = 0.030072489999999993
p50  = 0.030072500000000002
p75  = 0.03044225
p95  = 0.031131350000000002

Truncating data
---
Generating 1000000 row(s) of data
Sorting 100 time(s)

min  = 0.369679
max  = 0.415828
mean = 0.37722392999999976             # ~53.9% reduction
p50  = 0.375751
p75  = 0.37938125
p95  = 0.38539415                      # ~54.7% reduction

Truncating data
---
Generating 10000000 row(s) of data
Sorting 100 time(s)

min  = 4.630163
max  = 4.914647
mean = 4.671883840000002               # ~60.7% reduction
p50  = 4.661291
p75  = 4.6916195
p95  = 4.7220945500000004              # ~60.9% reduction

Truncating data
```
