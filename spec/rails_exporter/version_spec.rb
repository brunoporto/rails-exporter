require 'rails_helper'

describe RailsExporter do

  it 'have version number' do
    expect(RailsExporter::VERSION).not_to be_nil
  end

end