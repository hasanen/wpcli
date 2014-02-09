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
            if single_value_response
              rows << {} unless rows.size == 1
              parsed_line = parse_line(line, separator)
              rows.first[parsed_line[:field].to_sym] = parsed_line[:value]
            else
              rows << parse_line(line, separator)
            end
          end
        end
      end
      rows
    end

    def parse_header line, separator
      columns = []
      line.split(separator).each_with_index do |column, index|
        detect_if_line_is_from_single_value_response column
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

    def detect_if_line_is_from_single_value_response column
      @single_value = column.strip.downcase == "field" unless @single_value
    end

    def single_value_response
      @single_value
    end
  end
end