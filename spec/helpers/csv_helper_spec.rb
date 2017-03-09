require "rails_helper"

RSpec.describe CsvHelper, type: :helper do
  describe "#create_csv_string" do
    it "should return csv headers" do
      headers = ['test2', 'test2']

      expect(CsvHelper.create_csv_string(headers: headers, values: [])).to eq "Test2,Test2\n"
    end

    it "should return csv values" do
      values = [["a", "b", "c"]]

      expect(CsvHelper.create_csv_string(values: values)).to eq "a,b,c\n"
    end
    
    it "should return csv with headers and values" do
      headers = ['test', 'test']
      values = [['lorem', 'ipsum']]
      
      expect(CsvHelper.create_csv_string(values: values, headers: headers)).to eq "Test,Test\nlorem,ipsum\n"
    end
  end
end