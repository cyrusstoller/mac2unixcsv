require 'optparse'
require 'yaml'
require 'csv'

def main(options = {}, input_filename, output_filename)
  options = finalize_options(options)
  output_file = File.open(output_filename, "w")
  
  add_quotes(output_file, input_filename, options)
  
  output_file.close
  puts "All jobs done"
end

def add_quotes(output_file, input_filename, options)
  row_num = 0
  CSV.parse(File.read(input_filename)).each do |row|
    row_num += 1
    next if row_num < options[:header_rows] + 1
    p row if options[:verbose]
    output_file << row.map {|c| %Q("#{c}")}.join(",") + "\r\n"
  end
end

def finalize_options(options)
  default_options = YAML.load_file('defaults.yml')
  res = { 
          :verbose => default_options["verbose"],
          :header_rows => default_options["header_rows"]
        }
  res.merge(options)
end

if __FILE__ == $PROGRAM_NAME
  options = {}
  opts = OptionParser.new do |opts|
    opts.banner = "Usage: mac2unixcsv.rb [options] INFILE OUTFILE"
    
    opts.on( '-h', '--help', 'Help' ) do
      puts opts
      exit!
    end
    
    opts.on('-i NUM', '--ignore-rows=NUM', Integer, "Number of header rows to ignore") do |h|
      options[:header_rows] = h
    end
    
    opts.on('-v', '--[no-]verbose', "Verbose mode" ) do |v|
      options[:verbose] = v
    end
  end
  
  begin
    opts.parse(ARGV)
  rescue Exception => e
    puts e, opts
    exit
  end
  
  infile = opts.order(ARGV)[0]
  outfile = opts.order(ARGV)[1]
  if infile.nil? or outfile.nil?
    puts "Oops you need to give us some more info", opts
    exit
  end
  
  main(options, infile, outfile)
end