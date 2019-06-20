require_relative 'utils'

Sequel.migration do
  up do
    create_table(:ark_identifier) do
      primary_key :id

      Integer :resource_id
      Integer :accession_id
      Integer :digital_object_id

      index :resource_id
      index :accession_id
      index :digital_object_id
    end
  end

  down do
    drop_table(:ark_identifier)
  end
end
