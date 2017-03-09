module CsvHelper
  def self.create_csv_string(values:, headers: [])
    CSV.generate do |csv|
      csv << headers.map(&:humanize) unless headers.empty?
      values.each do |row|
        csv << row
      end
    end
  end
end
