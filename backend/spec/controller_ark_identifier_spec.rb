require 'spec_helper'

describe 'ARK Identifier controller' do
  it "should resolve a resource" do
    resource = create_resource(:title => generate(:generic_title))
    ark = ARKIdentifier.first(:resource_id => resource.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["id"]).to eq(resource.id)
    expect(response_hash["repo_id"]).to eq(resource.repo_id)
    expect(response_hash["type"]).to eq("Resource")

    resource.delete
  end

  
  it "should redirect to accession" do
    accession = create_accession
    ark = ARKIdentifier.first(:accession_id => accession.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["id"]).to eq(accession.id)
    expect(response_hash["repo_id"]).to eq(accession.repo_id)
    expect(response_hash["type"]).to eq("Accession")

    accession.delete
  end

  it "should redirect to digital object" do
    json = build(:json_digital_object)
    digital_object = DigitalObject.create_from_json(json)
    ark = ARKIdentifier.first(:digital_object_id => digital_object.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["id"]).to eq(digital_object.id)
    expect(response_hash["repo_id"]).to eq(digital_object.repo_id)
    expect(response_hash["type"]).to eq("DigitalObject")

    digital_object.delete
  end


  it "should redirect to archival object" do
    json = build(:json_archival_object)
    archival_object = ArchivalObject.create_from_json(json)
    ark = ARKIdentifier.first(:archival_object_id => archival_object.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["id"]).to eq(archival_object.id)
    expect(response_hash["repo_id"]).to eq(archival_object.repo_id)
    expect(response_hash["type"]).to eq("ArchivalObject")

    archival_object.delete
  end


  it "should redirect to digital object component" do
    json = build(:json_digital_object_component)
    doc = DigitalObjectComponent.create_from_json(json)
    ark = ARKIdentifier.first(:digital_object_component_id => doc.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["id"]).to eq(doc.id)
    expect(response_hash["repo_id"]).to eq(doc.repo_id)
    expect(response_hash["type"]).to eq("DigitalObjectComponent")

    doc.delete
  end


  it "should return 404 if ark_id not found" do
    get "/ark:/f00001/42"

    response_hash = JSON.parse(last_response.body)
    expect(response_hash["type"]).to eq("not_found")
  end

  it "should redirect to external_ark_url in resource if defined" do
    resource = create_resource(:title => generate(:generic_title),
                               :external_ark_url => "http://foo.bar/ark:/123/123")
    ark = ARKIdentifier.first(:resource_id => resource.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["type"]).to eq("external")
    expect(response_hash["external_url"]).to eq(resource.external_ark_url)

    resource.delete
  end

  it "should redirect to external_ark_url in accession if defined" do
    accession = create_accession(:external_ark_url => "http://foo.bar/ark:/123/123")
    ark = ARKIdentifier.first(:accession_id => accession.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["type"]).to eq("external")
    expect(response_hash["external_url"]).to eq(accession.external_ark_url)

    accession.delete
  end

  it "should redirect to external_ark_url in digital_object if defined" do
    json = build(:json_digital_object, {:external_ark_url => "http://foo.bar/ark:/123/123" })
    digital_object = DigitalObject.create_from_json(json)
    ark = ARKIdentifier.first(:digital_object_id => digital_object.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["type"]).to eq("external")
    expect(response_hash["external_url"]).to eq(digital_object.external_ark_url)

    digital_object.delete
  end


  it "should redirect to external_ark_url in archival_object if defined" do
    json = build(:json_archival_object, {:external_ark_url => "http://foo.bar/ark:/123/123" })
    archival_object = ArchivalObject.create_from_json(json)
    ark = ARKIdentifier.first(:archival_object_id => archival_object.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["type"]).to eq("external")
    expect(response_hash["external_url"]).to eq(archival_object.external_ark_url)

    archival_object.delete
  end


  it "should redirect to external_ark_url in digital_object_component if defined" do
    json = build(:json_digital_object_component, {:external_ark_url => "http://foo.bar/ark:/123/123" })
    doc = DigitalObjectComponent.create_from_json(json)
    ark = ARKIdentifier.first(:digital_object_component_id => doc.id)

    get "/ark:/f00001/#{ark.id}"
    response_hash = JSON.parse(last_response.body)

    expect(response_hash["type"]).to eq("external")
    expect(response_hash["external_url"]).to eq(doc.external_ark_url)

    doc.delete
  end
end
