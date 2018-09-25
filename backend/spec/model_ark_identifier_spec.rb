require 'spec_helper'

describe 'ARKIdentifier model' do 

  it "creates a ARKIdentifier to a resource when a resource is created" do
    resource = create_resource(:title => generate(:generic_title))
    ark = ARKIdentifier.where(:resource_id => resource[:id]).first

    expect(ARKIdentifier[ark[:id]].resource_id).to eq(resource[:id])

    resource.delete
  end

  it "creates an ARKIdentifier to a digital_object" do
    json = build(:json_digital_object)
    digital_object = DigitalObject.create_from_json(json)
    ark = ARKIdentifier.where(:digital_object_id => digital_object[:id]).first

    expect(ARKIdentifier[ark[:id]].digital_object_id).to eq(digital_object[:id])

    digital_object.delete
  end

  it "creates an ARKIdentifier to an accession" do
    accession = create_accession
    ark = ARKIdentifier.where(:accession_id => accession[:id]).first

    expect(ARKIdentifier[ark[:id]].accession_id).to eq(accession[:id])

    accession.delete
  end

  it "creates an ARKIdentifier to an archival object" do
    ao = ArchivalObject.create_from_json(
      build(
        :json_archival_object,
        :title => 'A new archival object'
      ),
      :repo_id => $repo_id)

    ark = ARKIdentifier.where(:archival_object_id => ao[:id]).first

    expect(ARKIdentifier[ark[:id]].archival_object_id).to eq(ao[:id])

    ao.delete
  end


  it "creates an ARKIdentifier to a digital_object_component" do
    doc = create(:json_digital_object_component)
    doc_row = DigitalObjectComponent.first

    ark = ARKIdentifier.where(:digital_object_component_id => doc_row[:id]).first


    expect(ARKIdentifier[ark[:id]].digital_object_component_id).to eq(doc_row[:id])
    expect(doc_row[:id]).to_not be_nil

    doc.delete
  end


  it "must specify at least one of resource, accession, digital object, archival object, or digital object component" do
    expect{ ark = ARKIdentifier.create }.to raise_error(Sequel::ValidationFailed)
  end


  it "cannot link to more than one type of resource" do
    resource = create_resource(:title => generate(:generic_title))
    accession = create_accession
    json = build(:json_digital_object)
    digital_object = DigitalObject.create_from_json(json)

    ao = ArchivalObject.create_from_json(
      build(
           :json_archival_object,
           :title => 'A new archival object'
           ),
     :repo_id => $repo_id)   

    doc = create(:json_digital_object_component)
    doc_row = DigitalObjectComponent.last

    # delete the auto created ARKIdentifiers for text
    ARKIdentifier.where(:resource_id => resource.id).delete
    ARKIdentifier.where(:digital_object_id => digital_object.id).delete
    ARKIdentifier.where(:accession_id => accession.id).delete
    ARKIdentifier.where(:archival_object_id => ao.id).delete
    ARKIdentifier.where(:digital_object_component_id => doc_row[:id]).delete


    expect{ ark = ARKIdentifier.create(:accession_id => accession[:id],
                                       :resource_id => resource[:id]) }.to raise_error(Sequel::ValidationFailed)

    expect{ ark = ARKIdentifier.create(:accession_id => accession[:id],
                                       :digital_object_id => digital_object[:id]) }.to raise_error(Sequel::ValidationFailed)

    expect{ ark = ARKIdentifier.create(:digital_object_id => digital_object[:id],
                                       :resource_id => resource[:id]) }.to raise_error(Sequel::ValidationFailed)

    expect{ ark = ARKIdentifier.create(:digital_object_id => digital_object[:id],
                                       :accession_id => accession[:id],
                                       :resource_id => resource[:id]) }.to raise_error(Sequel::ValidationFailed)   

    expect{ ark = ARKIdentifier.create(:digital_object_id => digital_object[:id],
                                       :archival_object_id => ao[:id] )}.to raise_error(Sequel::ValidationFailed)

    expect{ ark = ARKIdentifier.create(:digital_object_id => digital_object[:id],
                                       :digital_object_component_id => doc_row[:id])}.to raise_error(Sequel::ValidationFailed)
  end

  it "must link to a unique resource" do
    # ARK is created with resource
    resource = create_resource(:title => generate(:generic_title))

    # duplicate raises validation exception
    expect{ ARKIdentifier.create(:resource_id => resource[:id]) }.to raise_error(Sequel::ValidationFailed)

    resource.delete
  end

  it "must link to a unique accession" do
    # ARK is created with accession
    accession = create_accession

    # duplicate raises validation exception
    expect{ ARKIdentifier.create(:accession_id => accession[:id]) }.to raise_error(Sequel::ValidationFailed)

    accession.delete
  end

  it "must link to a unique digital_object" do
    # ARK is created with digital object
    json = build(:json_digital_object)
    digital_object = DigitalObject.create_from_json(json)

    # duplicate raises validation exception
    expect{ ARKIdentifier.create(:digital_object_id => digital_object[:id]) }.to raise_error(Sequel::ValidationFailed)

    digital_object.delete
  end


  it "must link to a unique archival_object" do
    # ARK is created with archival_object
    ao = ArchivalObject.create_from_json(
      build(
           :json_archival_object,
           :title => 'A new archival object'
           ),
     :repo_id => $repo_id)   


    # duplicate raises validation exception
    expect{ ARKIdentifier.create(:archival_object_id => ao[:id]) }.to raise_error(Sequel::ValidationFailed)

    ao.delete
  end

  it "must link to a unique digital_object_component" do
    # ARK is created with digital_object_component
    doc = create(:json_digital_object_component)
    doc_row = DigitalObjectComponent.last

    # duplicate raises validation exception
    expect{ ARKIdentifier.create(:digital_object_component_id => doc_row[:id]) }.to raise_error(Sequel::ValidationFailed)

    doc.delete
  end


  it "creates an ARK url for digital_object" do
    json = build(:json_digital_object)
    digital_object = DigitalObject.create_from_json(json, :repo_id => $repo_id)
    ark = ARKIdentifier.first(:digital_object_id => digital_object.id)

    expect(ARKIdentifier::get_ark_url(digital_object.id, :digital_object)).to eq("#{AppConfig[:ark_url_prefix]}/ark:/#{AppConfig[:ark_naan]}/#{ark.id}")

    digital_object.delete
  end

  it "creates an ARK url for an accession" do
    accession = create_accession
    ark = ARKIdentifier.first(:accession_id => accession.id)

    expect(ARKIdentifier::get_ark_url(accession.id, :accession)).to eq("#{AppConfig[:ark_url_prefix]}/ark:/#{AppConfig[:ark_naan]}/#{ark.id}")

    accession.delete
  end

  it "creates an ARK url for resource" do
    opts = {:title => generate(:generic_title)}
    resource = create_resource(opts)
    ark = ARKIdentifier.first(:resource_id => resource.id)

    expect(ARKIdentifier::get_ark_url(resource.id, :resource)).to eq("#{AppConfig[:ark_url_prefix]}/ark:/#{AppConfig[:ark_naan]}/#{ark.id}")

    resource.delete
  end


  it "creates an ARK url for archival_object" do
    ao = ArchivalObject.create_from_json(
      build(
        :json_archival_object,
        :title => 'A new archival object'
      ),
      :repo_id => $repo_id)

    ark = ARKIdentifier.first(:archival_object_id => ao.id)

    expect(ARKIdentifier::get_ark_url(ao.id, :archival_object)).to eq("#{AppConfig[:ark_url_prefix]}/ark:/#{AppConfig[:ark_naan]}/#{ark.id}")

    ao.delete
  end

  it "creates an ARK url for digital_object_component" do
    doc = create(:json_digital_object_component)
    doc_row = DigitalObjectComponent.first

    ark = ARKIdentifier.first(:digital_object_component_id => doc_row[:id])

    expect(ARKIdentifier::get_ark_url(doc_row[:id], :digital_object_component)).to eq("#{AppConfig[:ark_url_prefix]}/ark:/#{AppConfig[:ark_naan]}/#{ark.id}")

    doc.delete
  end


  it "get_ark_url returns external_ark_url if defined on the resource" do
    external_ark_url = "http://foo.bar/ark:/123/123"
    opts = {:title => generate(:generic_title), 
                      external_ark_url: external_ark_url}
    resource = create_resource(opts)
    ark = ARKIdentifier.first(:resource_id => resource.id)

    expect(ARKIdentifier::get_ark_url(resource.id, :resource)).to eq("http://foo.bar/ark:/123/123")

    resource.delete
  end

  it "get_ark_url returns external_ark_url if defined on the accession" do
    external_ark_url = "http://foo.bar/ark:/123/123"
    opts = {:title => generate(:generic_title), 
                      external_ark_url: external_ark_url}
    accession = create_accession(opts)
    ark = ARKIdentifier.first(:accession_id => accession.id)

    expect(ARKIdentifier::get_ark_url(accession.id, :accession)).to eq("http://foo.bar/ark:/123/123")

    accession.delete
  end

   it "get_ark_url returns external_ark_url if defined on the digital object" do
    external_ark_url = "http://foo.bar/ark:/123/123"
    opts = {:title => generate(:generic_title), 
                      external_ark_url: external_ark_url}
    digital_object = create_digital_object(opts)
    ark = ARKIdentifier.first(:digital_object_id => digital_object.id)

    expect(ARKIdentifier::get_ark_url(digital_object.id, :digital_object)).to eq("http://foo.bar/ark:/123/123")

    digital_object.delete
  end


  it "get_ark_url returns external_ark_url if defined on the archival object" do
    external_ark_url = "http://foo.bar/ark:/123/123"

    ao = ArchivalObject.create_from_json(
      build(
        :json_archival_object,
        :title => 'A new archival object',
        :external_ark_url => external_ark_url
      ),
      :repo_id => $repo_id)

    ark = ARKIdentifier.first(:archival_object_id => ao.id)

    expect(ARKIdentifier::get_ark_url(ao.id, :archival_object)).to eq("http://foo.bar/ark:/123/123")

    ao.delete
  end


  it "get_ark_url returns external_ark_url if defined on the digital_object_component" do
    external_ark_url = "http://foo.bar/ark:/123/123"

    doc = create(:json_digital_object_component, 
        {:external_ark_url => external_ark_url})
    doc_row = DigitalObjectComponent.first

    ark = ARKIdentifier.first(:digital_object_component_id => doc_row[:id])

    expect(ARKIdentifier::get_ark_url(doc_row[:id], :digital_object_component)).to eq("http://foo.bar/ark:/123/123")

    doc.delete
  end

end
