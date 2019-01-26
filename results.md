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

min  = 0.0003
max  = 0.001023
mean = 0.00033108
p50  = 0.0003155
p75  = 0.000332
p95  = 0.0003739999999999999

Truncating data
---
Generating 10000 row(s) of data
Sorting 100 time(s)

min  = 0.002419
max  = 0.003389
mean = 0.0025243999999999996
p50  = 0.0024935
p75  = 0.00254375
p95  = 0.0026770500000000003

Truncating data
---
Generating 100000 row(s) of data
Sorting 100 time(s)

min  = 0.039816
max  = 0.071363
mean = 0.04101494
p50  = 0.040375
p75  = 0.040601250000000005
p95  = 0.04183175

Truncating data
---
Generating 1000000 row(s) of data
Sorting 100 time(s)

min  = 0.486035
max  = 0.531021
mean = 0.49609569999999986        # ~39.3% improvement
p50  = 0.493289
p75  = 0.497853
p95  = 0.51513555                 # ~39.4% improvement

Truncating data
---
Generating 10000000 row(s) of data
Sorting 100 time(s)

min  = 6.749011
max  = 7.306028
mean = 6.879143770000004          # ~42.1% improvement
p50  = 6.864981
p75  = 6.90597525
p95  = 7.00636535                 # ~42.0% improvement

Truncating data
```
