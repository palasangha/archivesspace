require 'spec_helper'
require 'erb'
require_relative '../app/lib/reports/report_response'

describe AccessionDeaccessionsListReport do
  let(:datab) { Sequel.connect(AppConfig[:db_url]) }
  let(:report) { AccessionDeaccessionsListReport.new({:repo_id => 2},
                                {},
                                datab) }
  it 'returns the correct fields for the Accessions Acquired and Linked Deaccession Records report' do
    expect(report.query.first.keys.length).to eq(8)
    expect(report.query.first).to have_key(:accessionId)
    expect(report.query.first).to have_key(:repo_id)
    expect(report.query.first).to have_key(:accessionNumber)
    expect(report.query.first).to have_key(:title)
    expect(report.query.first).to have_key(:accessionDate)
    expect(report.query.first).to have_key(:extentNumber)
    expect(report.query.first).to have_key(:extentType)
    expect(report.query.first).to have_key(:containerSummary)
    # expect(report.query.first).to have_key(:deaccessionId)
    # expect(report.query.first).to have_key(:description)
    # expect(report.query.first).to have_key(:notification)
    # expect(report.query.first).to have_key(:deaccessionDate)
    # expect(report.query.first).to have_key(:extentNumber)
    # expect(report.query.first).to have_key(:extentType)
  end
  it 'has the correct template name' do
    expect(report.template).to eq('accession_deaccessions_list_report.erb')
  end
  it 'renders the expected report' do
    rend = ReportErbRenderer.new(report, {})
    expect(rend.render(report.template)).to include('Accessions Acquired and Linked Deaccession Records')
    expect(rend.render(report.template)).to include('accession_deaccessions_subreport.erb')
  end
end
