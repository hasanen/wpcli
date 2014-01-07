module Wpcli
  class Client
    def initialize path = ""
      @path = path
    end
    def run command
      output = `wp#{@path.empty? ? " " : " --path=" + @path + " "}#{command}`
      parse output
    end

    private

    def parse text
      first_data_row = starts_with_plus?(text) ? 3 : 1
      rows = []
      text.split("\n").each_with_index do |line, index|
        unless starts_with_plus? line
          separator = line.include?('|') ? '|' : "\t"
          if index < first_data_row
            @columns = parse_header line, separator
          else
            rows << parse_line(line, separator)
          end
        end
      end
      rows
    end

    def parse_header line, separator
      columns = []
      line.split(separator).each_with_index do |column, index|
        columns[index] = column.strip.downcase unless column.strip.empty?
      end
      columns
    end
    def parse_line line, separator
      hash = {}
      line.split(separator).each_with_index do |column, index|
        hash[@columns[index].to_sym] = column.strip unless @columns[index].nil?
      end
      hash
    end

    def starts_with_plus? line
      line.start_with? "+"
    end
  end
end