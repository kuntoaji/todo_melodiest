require 'yaml'

class TodoMelodiest < Melodiest::Application
  cookie_secret '97baced82abb08a24d14a24cd347cf87ebf4597cee8ad3dfc236d227ce1b0761'

  set :app_file, __FILE__
  set :views, Proc.new { File.join(root, "app/views") }
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier

  register Sinatra::AssetPipeline
  use Rack::Csrf, raise: true

  configure do
    Sequel::Database.extension :pagination
    Sequel::Model.plugin :timestamps
    Sequel::Model.plugin :auto_validations,
      not_null: :presence, unique_opts: { only_if_modified: true }
  end

  configure :development do
    require 'logger'

    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['development'],
      loggers: [Logger.new($stdout)]
  end

  configure :test do
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['test']
  end

  configure :production do
    # Serve assets via Nginx or Apache
    disable :static

    register Sinatra::Cache
    set :cache_enabled, true
    set :cache_output_dir, Proc.new { File.join(root, "public/cache") }

    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['production']
  end
end
