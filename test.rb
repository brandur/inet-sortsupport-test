

$debug = false
$num_assertions_run = 0

ABBREV_BITS_INET_FAMILY = 1
ABBREV_BITS_INET4_NETMASK_SIZE = 6
ABBREV_BITS_INET4_SUBNET = 25

BITS_PER_BYTE = 8
BYTES_IP_V4 = 4
BYTES_IP_V6 = 16

IP_V4 = Module.new.freeze
IP_V6 = Module.new.freeze

class IPAddress
  attr_reader :bytes             # array[bytes/integers between 0 and 255]
  attr_reader :ip_family         # IP_V4 or IP_V6
  attr_reader :num_netmask_bits  # integer

  def initialize(ip_family, bytes, num_netmask_bits)
    if ip_family != IP_V4 && ip_family != IP_V6
      raise ArgumentError, "invalid IP family: #{ip_family}"
    end

    if bytes.length != 16
      raise ArgumentError, "bytes must always be exactly length 16"
    end

    if ip_family == IP_V4
      if bytes[4...16] != [0] * 12
        raise ArgumentError, "bytes in IPv4 must have 12 zeroed bytes at the end"
      end

      if num_netmask_bits < 0 || num_netmask_bits > BYTES_IP_V4 * BITS_PER_BYTE
        raise ArgumentError, "bitmask bits must be 0-#{BYTES_IP_V4 * BITS_PER_BYTE}"
      end
    end

    if ip_family == IP_V6
      if bytes.length != 16
        raise ArgumentError, "bytes in IPv6 must be exactly length 16"
      end

      if num_netmask_bits < 0 || num_netmask_bits > BYTES_IP_V6 * BITS_PER_BYTE
        raise ArgumentError, "bitmask bits must be 0-#{BYTES_IP_V6 * BITS_PER_BYTE}"
      end
    end

    bytes.each_with_index do |b, i|
      if b < 0 || b > 255
        raise ArgumentError, "byte at position #{i} must be 0-255"
      end
    end

    @ip_family = ip_family
    @bytes = bytes
    @num_netmask_bits = num_netmask_bits
  end

  def ip_family_bits
    if ip_family == IP_V6
      BYTES_IP_V6 * BITS_PER_BYTE
    else
      BYTES_IP_V4 * BITS_PER_BYTE
    end
  end

  def to_s
    bytes_str = if ip_family == IP_V4
      bytes[0...4].map { |b| b.to_s }.join(".")
    else
      # No fancy abbreviations (by design)
      bytes.each_slice(2).map { |(b1, b2)| '%02X%02X' % [b1, b2] }.join(":").downcase
    end
    bytes_str + "/" + num_netmask_bits.to_s
  end
end

def assert_equal(expected, actual)
  if expected != actual
    raise ArgumentError, <<~eos
      assert_equal failed
        Expected: #{expected}
        Actual:   #{actual}
    eos
  end

  $num_assertions_run += 1
end

def debug(str)
  puts(str) if $debug
end

def inet_abbreviate_key(sizeof_datum, ipaddr)
  if sizeof_datum != 4 && sizeof_datum != 8
    raise ArgumentError, "sizeof_datum must be 4 or 8"
  end

  res = 0
  if ipaddr.ip_family == IP_V6
    res = 1
    res <<= sizeof_datum * BITS_PER_BYTE - ABBREV_BITS_INET_FAMILY
  end

  ipaddr_int = 0
  ipaddr_int |= ipaddr.bytes[0]
  ipaddr_int <<= 8
  ipaddr_int |= ipaddr.bytes[1]
  ipaddr_int <<= 8
  ipaddr_int |= ipaddr.bytes[2]
  ipaddr_int <<= 8
  ipaddr_int |= ipaddr.bytes[3]

  if sizeof_datum == 8
    ipaddr_int <<= 8
    ipaddr_int |= ipaddr.bytes[4]
    ipaddr_int <<= 8
    ipaddr_int |= ipaddr.bytes[5]
    ipaddr_int <<= 8
    ipaddr_int |= ipaddr.bytes[6]
    ipaddr_int <<= 8
    ipaddr_int |= ipaddr.bytes[7]
  end

  debug("ipaddr_int (after direct ingestion) =\n#{stringify_int(ipaddr_int)} (#{ipaddr_int})")

  if sizeof_datum == 8 && ipaddr.ip_family == IP_V4
    ipaddr_int >>= sizeof_datum * BITS_PER_BYTE - BYTES_IP_V4 * BITS_PER_BYTE
  end

  debug("ipaddr_int (after maybe shift) =\n#{stringify_int(ipaddr_int)} (#{ipaddr_int})")

  netmask_int = ipaddr_int
  subnet_int = 0
  datum_subnet_size = 0

  datum_size_left = sizeof_datum * BITS_PER_BYTE - ipaddr.num_netmask_bits - 1
  debug("datum_size_left = #{datum_size_left}")

  datum_subnet_size = [ipaddr.ip_family_bits - ipaddr.num_netmask_bits, datum_size_left].min
  debug("datum_subnet_size = #{datum_subnet_size}")

  subnet_bitmask = (1 << [0, datum_subnet_size].max) - 1
  debug("subnet_bitmask =\n#{stringify_int(subnet_bitmask)}")

  subnet_int = ipaddr_int & subnet_bitmask
  debug("subnet_int =\n#{stringify_int(subnet_int)}")

  netmask_int = ipaddr_int - subnet_int
  debug("netmask_int =\n#{stringify_int(netmask_int)}")

  if sizeof_datum == 8

    if ipaddr.ip_family == IP_V6

      res |= netmask_int >> ABBREV_BITS_INET_FAMILY

    else

      netmask_size_and_subnet = 0

      # an IPv4 netmask has a maximum value of 32 which takes 6 bits to contain
      netmask_size = ipaddr.num_netmask_bits

      raise "netmask_size should be 0-32" unless netmask_size >= 0 && netmask_size <= BYTES_IP_V4 * BITS_PER_BYTE
      netmask_size_and_subnet |= netmask_size << ABBREV_BITS_INET4_SUBNET
      debug("netmask_size_and_subnet after shifting netmask size (#{netmask_size}) left #{ABBREV_BITS_INET4_SUBNET} and OR =\n#{stringify_int(netmask_size_and_subnet)}")

      # if we have more than ABBREV_BITS_INET4_SUBNET subnet bits of information, shift it down
      # to the available size
      if datum_subnet_size > ABBREV_BITS_INET4_SUBNET
        subnet_int >>= datum_subnet_size - ABBREV_BITS_INET4_SUBNET
        debug("subnet_int after shifting right by #{datum_subnet_size - ABBREV_BITS_INET4_SUBNET} =\n#{stringify_int(subnet_int)}")
      end
      netmask_size_and_subnet  |= subnet_int
      debug("netmask_size_and_subnet after OR with subnet int =\n#{stringify_int(netmask_size_and_subnet)}")
      debug("0x7fffffff =\n#{stringify_int(0x7fffffff)}")
      debug("0xffffffff80000000 =\n#{stringify_int(0xffffffff80000000)}")

      raise "unexpected bits set on netmask_size_and_subnet " if netmask_size_and_subnet | 0x7fffffff != 0x7fffffff

      # 31 = 6 bits netmask size + 25 subnet bits
      netmask_shifted = netmask_int << ABBREV_BITS_INET4_NETMASK_SIZE + ABBREV_BITS_INET4_SUBNET
      debug("netmask int shifted left 31 =\n#{stringify_int(netmask_shifted)}")

      raise "unexpected bits set on netmask_shifted " if netmask_shifted & 0xffffffff80000000 != netmask_shifted

      res |= netmask_shifted | netmask_size_and_subnet
      debug("res after shifting netmask int left 31 and OR =\n#{stringify_int(res)}")

    end

  else

    res |= netmask_int >> ABBREV_BITS_INET_FAMILY

  end

  debug("final_res =\n#{stringify_int(res)}")
  res
end

# This is of course only a very rough approximation of a real parser (which
# would be much more robust). You're allowed in IPv6, for example, to embed an
# IPv4 address in the last four bytes. Needless to say, we don't support that
# kind of edge here.
def parse_ip(str)
  if str.include?(".")
    ip, netmask_bits = str.split("/")

    if netmask_bits.nil?
      netmask_bits = BYTES_IP_V4 * BITS_PER_BYTE
    else
      netmask_bits = netmask_bits.to_i
    end

    bytes = ip.split(".").map { |b| b.to_i}

    # Add an extra 12 zeroed bytes to simulate how an IPv4 is really stored in
    # Postgres' C code.
    bytes += [0] * 12

    IPAddress.new(IP_V4, bytes, netmask_bits)
  elsif str.include?(":")
    ip, netmask_bits = str.split("/")

    if netmask_bits.nil?
      netmask_bits = BYTES_IP_V6 * BITS_PER_BYTE
    else
      netmask_bits = netmask_bits.to_i
    end

    groups = ip.split(":")

    # An empty group indicates the presence of a double-colon `::`, which is
    # IPv6 abbreviations any number of groups of 0s in the address. If we see
    # one, just insert the groups we're missing for easier processing later.
    unless (double_colon_index = groups.index("")).nil?
      num_missing_groups = BYTES_IP_V6 / 2 - groups.length

      # Also add one for the empty element itself (which we'll replace).
      num_missing_groups += 1

      groups.delete_at(double_colon_index)
      groups.insert(double_colon_index, *num_missing_groups.times.map { "0" })
    end

    bytes = groups.map do |group|
      value = group.to_i(16)
      [value / 256, value % 256]
    end.flatten

    IPAddress.new(IP_V6, bytes, netmask_bits)
  else
    raise ArgumentError, "couldn't determine if IPv4 or IPv6"
  end
end

def stringify_int(int)
  str = int.to_s(16)

  # 2 = One byte represented by 2 characters. 8 = show a full 8 bytes for the
  # size of a uint64
  if str.length < 2 * 8
    str = "0" * (2 * 8 - str.length) + str
  end

  str.chars.each_slice(2).map { |b1, b2| "#{b1}#{b2}" }.join(" " ) + " (#{int})"
end

#
# tests
#

def test_inet_abbreviate_key
  assert_equal "00 81 01 80 30 00 00 04 (36311922068422660)",
    stringify_int(inet_abbreviate_key(
      8, parse_ip("1.2.3.4/24")))

  assert_equal "00 00 00 00 00 02 04 06 (132102)",
    stringify_int(inet_abbreviate_key(
      8, parse_ip("1.2.3.4/0")))

  assert_equal "ff ff c1 f3 f8 8c 2b ee (18446675852323990510)",
    stringify_int(inet_abbreviate_key(
      8, parse_ip("ffff:83e7:f118:57dc:6093:6d92:689d:58cf/70")))
end

def test_parse_ip
  assert_equal "1.2.3.4/24", parse_ip("1.2.3.4/24").to_s

  assert_equal "1.2.3.5/32", parse_ip("1.2.3.5").to_s

  assert_equal "ffff:83e7:f118:57dc:6093:6d92:689d:58cf/70",
    parse_ip("ffff:83e7:f118:57dc:6093:6d92:689d:58cf/70").to_s

  assert_equal "0127:0000:0000:0000:0000:0000:0000:0001/128",
    parse_ip("127::1").to_s

  assert_equal "ff06:0000:0000:0000:0000:0000:0000:00c3/128",
    parse_ip("ff06::c3").to_s
end

$debug = true if ENV["DEBUG"] == "true"

test_parse_ip
test_inet_abbreviate_key

puts "#{$num_assertions_run} assertion(s) succeeded"
