require_relative 'utils'

# moves external_id field from the ARKs table to resource, accession and digital objects tables, respectively.
Sequel.migration do
  up do
    alter_table(:ark_identifier) do
      add_column(:archival_object_id, Integer)
      add_column(:digital_object_component_id, Integer)

      add_index :archival_object_id
      add_index :digital_object_component_id
    end

    alter_table(:archival_object) do
      add_column(:external_ark_url, String)
    end

    alter_table(:digital_object_component) do
      add_column(:external_ark_url, String)
    end
  end
end

