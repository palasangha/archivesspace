{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "/ark:/:naan/:ark_id",
    "properties" => {
      "resource_id"                 => {"type" => "integer", "required" => false},
      "accession_id"                => {"type" => "integer", "required" => false},
      "digital_object_id"           => {"type" => "integer", "required" => false},
      "archival_object_id"          => {"type" => "integer", "required" => false},
      "digital_object_component_id" => {"type" => "integer", "required" => false}
      }
  }
}

  