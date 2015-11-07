module TkgmapHelper
  def gmap_api_uri
    uri = 'https://maps.google.com/maps/api/js?v=3&sensor=false'
    uri << '&key=' << Setting.plugin_redmine_tkgmap['gmap_api_key'] if Setting.plugin_redmine_tkgmap['gmap_api_key'].present?
    uri
  end
end
