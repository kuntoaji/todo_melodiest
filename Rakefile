require_relative 'config/boot'
require_relative 'todo_sinator'

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    manifest = ::Sprockets::Manifest.new(TodoSinator.assets.index, "#{TodoSinator.public_folder}/assets")
    manifest.compile(TodoSinator.assets_manifest)
  end

  desc "Clean assets"
  task :clean do
    FileUtils.rm_rf("#{TodoSinator.public_folder}/assets")
  end
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    db = Sequel.connect(YAML.load_file("#{Sinator::ROOT}/config/database.yml")[ENV['RACK_ENV']])
    migration_path = "#{Sinator::ROOT}/db/migrations"

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, migration_path, target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, migration_path)
    end
  end
end

