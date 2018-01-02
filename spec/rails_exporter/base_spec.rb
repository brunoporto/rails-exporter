require 'rails_helper'

RSpec.describe RailsExporter::Base do

  describe '.file_types' do
    it 'return the supported file types' do
      expect(RailsExporter::Base.file_types).to eq([:csv, :xls, :xlsx, :xml])
    end
  end

end