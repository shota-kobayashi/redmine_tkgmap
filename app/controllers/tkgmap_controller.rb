class TkgmapController < ApplicationController
  unloadable
  layout 'tkgmap'

  def index
  end

  def window
  end

  def gmap_api_uri
    uri = 'https://maps.google.com/maps/api/js?v=3&sensor=false'
    uri << '&key=' << Setting.plugin_redmine_tkgmap['gmap_api_key'] if Setting.plugin_redmine_tkgmap['gmap_api_key'].present?
    uri
  end
  helper_method :gmap_api_uri

end
