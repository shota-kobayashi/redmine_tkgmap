require 'custom_fields_helper_patch'
require 'issues_helper_patch'

Redmine::Plugin.register :redmine_tkgmap do
  name 'Redmine Tkgmap plugin'
  author 'Shota.K'
  description 'Adding lat lng chooser with google map.(Redmine 2.3, 2,2...)'
  version '0.1'
  url 'https://github.com/shota-kobayashi/redmine_tkgmap'
  author_url 'https://github.com/shota-kobayashi/redmine_tkgmap'

  settings :default => {
		'map_width' => 400,
		'map_height' => 400,
		'default_lat' => 43.68731521012838,
		'default_lng' => -79.37548889160155
  }, :partial => 'settings/tkgmap_settings'
end

class Tkgmap < Redmine::CustomFieldFormat
	Identifier = "tkg"
	field_format = Identifier
	def format_as_tkg(value)
		value
	end
end

Redmine::CustomFieldFormat.map do |fields|
  fields.register Tkgmap.new('tkg', :label => :label_tkg, :order => 9)
end


Rails.configuration.to_prepare do
    unless CustomFieldsHelper.included_modules.include?(CustomFieldsHelperPatch)
        CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
    end  
    unless IssuesHelper.included_modules.include?(IssuesHelperPatch)
        IssuesHelper.send(:include, IssuesHelperPatch)
    end  
end
