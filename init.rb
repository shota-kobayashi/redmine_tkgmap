require 'custom_fields_helper_patch'
require 'issues_helper_patch'

Redmine::Plugin.register :redmine_tkgmap do
  name 'Redmine Tkgmap plugin'
  author 'Shota.K'
  description 'Adding lat lng chooser with google map.'
  version '0.2.0'
  url 'https://github.com/shota-kobayashi/redmine_tkgmap'
  author_url 'https://github.com/shota-kobayashi/redmine_tkgmap'

  settings :default => {
		'gmap_api_key' => '',
		'map_width' => 400,
		'map_height' => 400,
		'default_lat' => 43.68731521012838,
		'default_lng' => -79.37548889160155,
		'default_zoom' => 8,
  }, :partial => 'settings/tkgmap_settings'
end

class Tkgmap < Redmine::FieldFormat::Unbounded
	add 'tkg'
	Identifier = "tkg"
	
	def format_name
	 "tkg"
	end
	
	def label
	 "label_tkg"
	end
	
	def format_as_tkg(value)
		value
	end
end
Redmine::FieldFormat.add 'tkg', Tkgmap

Rails.configuration.to_prepare do
    unless CustomFieldsHelper.included_modules.include?(CustomFieldsHelperPatch)
        CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
    end  
    unless IssuesHelper.included_modules.include?(IssuesHelperPatch)
        IssuesHelper.send(:include, IssuesHelperPatch)
    end  
end
