require 'descriptive_statistics'
require 'sequel'

DB = Sequel.connect(ENV["DATABASE_URL"])
TABLE_NAME = :inet_sortsupport_tes

def create_indexes(num_times)
  puts "Generating index #{num_times} time(s)"
  puts ""

  data = []

  num_times.times do
    t = Time.now
    DB.run <<~eos
      CREATE INDEX index_inet ON #{TABLE_NAME} (ip);
    eos
    data << Time.now - t

    DB.run <<~eos
      DROP INDEX index_inet;
    eos
  end

  puts "min  = #{data.min}"
  puts "max  = #{data.max}"
  puts "mean = #{data.mean}"
  puts "p50  = #{data.percentile(50)}"
  puts "p75  = #{data.percentile(75)}"
  puts "p95  = #{data.percentile(95)}"
  puts ""
end

def create_schema
  puts "Generating schema"
  puts ""

  DB.run <<~eos
    DROP TABLE IF EXISTS #{TABLE_NAME};
  eos

  DB.run <<~eos
    CREATE TABLE #{TABLE_NAME} (
      id bigserial,
      ip inet
    );
  eos
end

def generate_data(num_rows)
  puts "---"
  puts "Generating #{num_rows} row(s) of data"

  generator = Random.new
  ips = DB[TABLE_NAME]

  # For faster script runs, bulk insert many at a time.
  num_rows.times.each_slice(1_000) do |slice|
    ip_tuples = slice.map do
      if generator.rand(2).even?
        {ip: generate_ipv6(generator)}
      else
        {ip: generate_ipv4(generator)}
      end
    end

    ips.multi_insert(ip_tuples)
  end
end

# Generates something like:
#
#     "246.56.173.186/4"
#
def generate_ipv4(generator)
  bytes = generator.bytes(4).each_byte.map { |b| b.to_s(10) }.join(".")

  # Generate netmask size between 0 and 32.
  bytes + "/#{generator.rand(33)}"
end

# Generates something like:
#
#     "e2b4:169f:a7cd:1dda:5a11:a114:73b:2a9b/106"
#
def generate_ipv6(generator)
  bytes = generator
    .bytes(16)
    .each_byte
    .map { |b| b.to_s(16) }
    .each_slice(2)
    .map { |(b1, b2)| b1 + b2 }
    .join(":")

  # Generate netmask size between 0 and 128.
  bytes + "/#{generator.rand(129)}"
end

def truncate_data
  puts "Truncating data"

  ips = DB[TABLE_NAME]
  ips.truncate
end

create_schema

[
       1_000,
      10_000,
     100_000,
   1_000_000,
  10_000_000,
].each do |num_rows|
  generate_data(num_rows)
  create_indexes(100)
  truncate_data
end
