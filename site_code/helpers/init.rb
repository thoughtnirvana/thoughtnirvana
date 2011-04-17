require 'digest/md5'

class App < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    # Auto-version static assets based on md5 or explicity supplied version.
    # Auto-versioned assets can have cache headers set to large durations.
    def auto_version(resource_id, use_hash=true, version=1)
      public_dir = settings.public || "public"
      views_dir = settings.views || "views"
      dev_js_dir = File.join views_dir, "coffee"
      dev_css_dir = File.join views_dir, "sass"
      dir_name, file_name = File.dirname(resource_id), File.basename(resource_id)

      if /(?<name>\w+)(?<ext>.\w+)/ =~ file_name
        # Hash not requested. Return explicitly versioned name.
        if not use_hash
          return File.join dir_name, "#{name}.#{version}#{ext}"
        else
          file_path = File.join public_dir, resource_id
          # Change file paths to point to coffee source for js and sass source for
          # css if running under development.
          env = settings.environment
          if env != "production"
            new_file_path = nil
            if ext == ".js"
              coffee_resource = file_name.sub(/\.js$/, '.coffee')
              new_file_path = File.join dev_js_dir, coffee_resource
            elsif ext == ".css"
              sass_resource = file_name.sub(/\.css$/, '.sass')
              new_file_path = File.join dev_css_dir, sass_resource
            end
            file_path = new_file_path if File.exist? new_file_path
          end
          md5 = "" 
          begin
            md5 = Digest::MD5.hexdigest IO.read(file_path)
          rescue IOError => ex
            puts ex
            return resource_id
          end
          return File.join dir_name, "#{name}.#{md5}#{ext}"
        end
      else
        return resource_id
      end
    end
  end
end
