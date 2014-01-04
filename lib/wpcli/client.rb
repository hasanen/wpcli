module Wpcli
  class Client
    def initialize path = ""
      case path
      when String
        @path = path
      end
      nil if @path.empty?
    end
    def run command
      output = `wp#{@path.empty? ? " " : " --path=" + @path + " "}#{command}`
      parse output
    end

    private

    def parse text
      rows = []
      text.split("\n").each_with_index do |line, index|
        unless separator? line
          if index < 3
            @columns = parse_header line
          else
            rows << parse_line(line)
          end
        end
      end
      rows
    end

    def parse_header line
      columns = []
      line.split('|').each_with_index do |column, index|
        columns[index] = column.strip.downcase unless column.strip.empty?
      end
      columns
    end
    def parse_line line
      hash = {}
      line.split('|').each_with_index do |column, index|
        hash[@columns[index].to_sym] = column.strip unless @columns[index].nil?
      end
      hash
    end

    def separator? line
      line.start_with? "+"
    end
  end
end