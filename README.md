# inet/cidr SortSupport test bootstrap

A test script designed to measure the performance before
and after a SortSupport patch for the inet/cidr types.

The script will try a series of different sample data
sizes, each containing random sets of IPv4/IPv6 addresses
with random netmask sizes, raise indexes on them many
times, then print the statistics for each sample data size.

## Instructions

```
direnv allow
bundle install
createdb inet-sortsupport-test
bundle exec ruby main.rb
```
