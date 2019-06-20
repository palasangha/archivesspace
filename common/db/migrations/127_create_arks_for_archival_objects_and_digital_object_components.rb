require_relative 'utils'

# populates the ark_identifier table with records for existing 
# resources, accessions, and digital objects
Sequel.migration do
  up do
    # archival_objects
    self[:archival_object].select(:id).each do |r|
      self[:ark_identifier].insert(:archival_object_id => r[:id],
                                   :created_by         => 'admin',
                                   :last_modified_by   => 'admin',
                                   :create_time        => Time.now,
                                   :system_mtime       => Time.now,
                                   :user_mtime         => Time.now,
                                   :lock_version       => 0)
    end

    # digital_object_components
    self[:digital_object_component].select(:id).each do |r|
      self[:ark_identifier].insert(:digital_object_component_id => r[:id],
                                   :created_by                  => 'admin',
                                   :last_modified_by            => 'admin',
                                   :create_time                 => Time.now,
                                   :system_mtime                => Time.now,
                                   :user_mtime                  => Time.now,
                                   :lock_version                => 0)
    end

  end
end