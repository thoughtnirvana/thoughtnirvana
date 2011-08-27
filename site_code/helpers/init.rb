class App < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    # Auto-version static assets based on timestamp or explicity supplied version.
    # Auto-versioned assets can have cache headers set to large durations.
    def auto_version(resource_path, version=nil)
      public_dir = settings.public || "public"

      # Auto-versioning not requested. Return explicitly versioned name.
      if version 
        return "#{resource_path};#{version}"
      else
        file_path = File.join public_dir, resource_path 
        file_path = translate_file_path(file_path, settings)
        return "#{resource_path};#{File.mtime(file_path).to_i}"
      end
    end

    # Changes file paths to point to coffee source for js and sass source for
    # css if running under development.
    def translate_file_path(file_path, settings)
      views_dir = settings.views
      dev_js_dir = File.join views_dir, "coffee"
      dev_css_dir = File.join views_dir, "sass"
      env = settings.environment

      if env != "production"
        new_file_path = nil
        if file_path.end_with? "js"
          coffee_resource = File.basename(file_path).sub(/\.js$/, '.coffee')
          new_file_path = File.join dev_js_dir, coffee_resource
        elsif file_path.end_with? "css"
          sass_resource = File.basename(file_path).sub(/\.css$/, '.sass')
          new_file_path = File.join dev_css_dir, sass_resource
        end
        file_path = new_file_path if new_file_path and File.exist? new_file_path
      end
      file_path
    end

  end
end
