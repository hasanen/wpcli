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
      lines = text.split("\n")
      return text.strip if lines.size == 1

      single_value = false
      first_data_row = starts_with_plus?(text) ? 3 : 1
      rows = []
      lines.each_with_index do |line, index|
        unless is_blank?(line) || starts_with_plus?(line)
          separator = line.include?('|') ? '|' : "\t"
          if index < first_data_row
            @columns = parse_header line, separator
            single_value = detect_if_line_is_from_single_value_response
          else
            if single_value
              parsed_line = parse_line(line, separator)
              value = parsed_line[:value]
              unless value.nil? || value == "null"
                rows << {} unless rows.size == 1
                rows.first[parsed_line[:field].to_sym] = value
              end
            else
              rows << parse_line(line, separator)
            end
          end
        end
      end
      rows
    end

    def is_blank? string
      string == nil || string.empty?
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

    def detect_if_line_is_from_single_value_response
      @columns.each do |column|
        return true if !column.nil? && column.strip.downcase == "field"
      end
      false
    end
  end
end
