require File.expand_path('../lib/tkgmap.rb', __FILE__)
require File.expand_path('../lib/tkgmap_custom_fields_helper_patch.rb', __FILE__)
require File.expand_path('../lib/tkgmap_issues_helper_patch.rb', __FILE__)

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

if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  Rails.application.config.after_initialize do
    unless CustomFieldsHelper.included_modules.include?(TkgmapCustomFieldsHelperPatch)
      CustomFieldsHelper.send(:include, TkgmapCustomFieldsHelperPatch)
    end
    unless IssuesHelper.included_modules.include?(TkgmapIssuesHelperPatch)
      IssuesHelper.send(:include, TkgmapIssuesHelperPatch)
    end
  end
else
  Rails.configuration.to_prepare do
    unless CustomFieldsHelper.included_modules.include?(TkgmapCustomFieldsHelperPatch)
      CustomFieldsHelper.send(:include, TkgmapCustomFieldsHelperPatch)
    end
    unless IssuesHelper.included_modules.include?(TkgmapIssuesHelperPatch)
      IssuesHelper.send(:include, TkgmapIssuesHelperPatch)
    end
  end
end
