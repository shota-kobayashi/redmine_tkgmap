require 'custom_fields_helper_patch'

Redmine::Plugin.register :redmine_tkgmap do
  name 'Redmine Tkgmap plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings :partial => 'settings/redmine_rt_custom_field_settings',
    :default => {
      'tkg_url' => 'http://path.to.rt.com/',
      'new_window' => 'true',
    }

end

class Tkgmap < Redmine::CustomFieldFormat
	field_format = "tkg"
  def format_as_tkg(value)
    if Setting.plugin_redmine_tkgmap['new_window'] == "true"
      target = 'blank'
    else
      target = ''
    end
    ActionController::Base.helpers.link_to(value, Setting.plugin_redmine_tkgmap['tkg_url'] + "Ticket/Display.html?id=" + value, :target => target)
  end
end

Redmine::CustomFieldFormat.map do |fields|
  fields.register Tkgmap.new('tkg', :label => :label_tkg, :order => 9)
end


Rails.configuration.to_prepare do
    unless CustomFieldsHelper.included_modules.include?(CustomFieldsHelperPatch)
        CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
    end  
end
