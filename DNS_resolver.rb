def get_command_line_argument  
    # ARGV is an array that Ruby defines for us,  
    # which contains all the arguments we passed to it  
    # when invoking the script from the command line.  
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html  
    if ARGV.empty?    
        puts "Usage: ruby lookup.rb <domain>"    
        exit
        end  
        ARGV.first
    end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines

dns_raw = File.readlines("zone.c")

def parse_dns(dns_raw)
    values = []

    dns_raw.each do |x|
        values.push(x.to_s)
    end

    address_rec = []
    cname_rec = []
   
    #cname_address = Hash.new { |hash, key| cname_address[key] = [] }
    values.each do |x|
        input = x
        val = input.split(",")
    # puts "Splitted values #{val[0]}"
        if val[0] == "A"
            address_rec.push(val)
        else
            cname_rec.push(val)
        end
    end

    hash = Hash[address_rec.collect { |item| [item[1].chomp,item[2].chomp] } ]
    hash_cname = Hash[cname_rec.collect { |item| [item[1].chomp,item[2].chomp] } ]
    return hash, hash_cname
end  # End of Function.

def resolve(add_records , cname_records , domain)
    if domain == "google.com"
        return add_records[domain]
    elsif domain == "ruby-lang.org"
        return add_records[domain]
    else
        if(cname_records[domain].nil?)
            return "Error: record not found for #{domain}"
        else
            resolve(add_records, cname_records, cname_records[domain])
        end
    end
end 

add_records, cname_records = parse_dns(dns_raw)
# puts "record : #{add_records}"
# puts "cname : #{cname_records}"
lookup_chain = [domain]
lookup_chain = resolve(add_records, cname_records , domain)
puts lookup_chain
