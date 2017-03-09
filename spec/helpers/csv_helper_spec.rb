require "rails_helper"

RSpec.describe CsvHelper, type: :helper do
  describe "#create_csv_string" do
    it "should return csv headers" do
      headers = ['tets2', 'test2']

      expect(CsvHelper.create_csv_string(headers: headers, values: [])).to eq(headers.map(&:humanize).join(',') + "\n")
    end

    it "should return csv values" do
      values = [["a", "b", "c"]]

      expect(CsvHelper.create_csv_string(values: values)).to eq (values.first.join(',') + "\n")
    end
    
    it "should return csv with headers and values" do
      headers = ['test', 'test']
      values = [['lorem', 'ipsum']]
      
      expected = headers.map(&:humanize).join(',') + "\n"
      expected += values.first.join(',') + "\n"
      
      expect(CsvHelper.create_csv_string(values: values, headers: headers)).to eq expected
    end
  end
end