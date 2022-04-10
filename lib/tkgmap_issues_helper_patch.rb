require_dependency 'issues_helper' unless Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?

module TkgmapIssuesHelperPatch
	def self.included(base)
		base.send(:prepend, InstanceMethods)
	end

	module InstanceMethods
		def show_tkgmap_value(value)
			sv = show_value(value)
			if (value.custom_field.field_format == Tkgmap::Identifier && sv =~ /\A-?[0-9\.]+,-?[0-9\.]+\Z/)
				content_for :header_tags do
					header_tags = []
					if Gem::Version.new([Redmine::VERSION::MAJOR, Redmine::VERSION::MINOR].join(".")) >= Gem::Version.new("3.2") # redmine >= 3.2
						# responsive layout support for redmine >= 3.2
						header_tags << stylesheet_link_tag('tkgmap_responsive.css', :plugin => 'redmine_tkgmap')
					end
					header_tags << javascript_include_tag('tkgmap_application',:plugin => 'redmine_tkgmap')
					header_tags << javascript_include_tag('showMapWindow',:plugin => 'redmine_tkgmap')
					header_tags << content_tag("script", "",{:src =>TkgmapController.helpers.gmap_api_uri, :type =>'text/javascript', :charset=>'UTF-8'})
					safe_join header_tags
				end

				s = String.new
				latLng = sv.split(",")
				default_zoom = 'undefined'
				default_zoom = Setting.plugin_redmine_tkgmap['default_zoom'].to_i if default_zoom.present?
				script ="//<![CDATA[
					$(function(){
						initMap(#{latLng[0]}, #{latLng[1]}, false, #{default_zoom});
					});
				//]]>"
				label = latLng.map{|v| h(v) }.join(',<wbr />')
				s << "<a href=\"https://maps.google.com/maps?q=#{latLng[0]},#{latLng[1]}\">#{label}</a><div id=\"gmap\" style=\"width:100%;height:200px;\"></div>"
				s << content_tag("script", script,{:type =>'text/javascript'})
				s.html_safe
			else
				sv
			end
		end
		private :show_tkgmap_value

		if Gem::Version.new([Redmine::VERSION::MAJOR, Redmine::VERSION::MINOR].join(".")) >= Gem::Version.new("3.4") # redmine >= 3.4

			def render_half_width_custom_fields_rows(issue)
				values = issue.try(:visible_custom_field_values) || issue.custom_field_values
				return if values.empty?
				half = (values.size / 2.0).ceil
				issue_fields_rows do |rows|
					values.each_with_index do |value, i|
						sv = (value.custom_field.field_format == Tkgmap::Identifier)? show_tkgmap_value(value) : show_value(value)

						css = "cf_#{value.custom_field.id}".dup
						css << ' tkgmap' if value.custom_field.field_format == Tkgmap::Identifier
						m = (i < half ? :left : :right)
						rows.send m, custom_field_name_tag(value.custom_field), sv, :class => css
					end
				end
			end

		elsif Gem::Version.new([Redmine::VERSION::MAJOR, Redmine::VERSION::MINOR].join(".")) >= Gem::Version.new("3.2") # redmine >= 3.2

			def render_custom_fields_rows(issue)
				values = issue.try(:visible_custom_field_values) || issue.custom_field_values
				return if values.empty?

				half = (values.size / 2.0).ceil

				issue_fields_rows do |rows|
					values.each_with_index do |value, i|
						if value.custom_field.field_format == Tkgmap::Identifier
							sv = show_tkgmap_value(value)
						else
							sv = simple_format_without_paragraph(h(show_value(value)))
						end

						css = "cf_#{value.custom_field.id}".dup
						css << ' tkgmap' if value.custom_field.field_format == Tkgmap::Identifier
						m = (i < half ? :left : :right)
						rows.send m, custom_field_name_tag(value.custom_field), sv, :class => css
					end
				end
			end
		else # redmine < 3.2

			def render_custom_fields_rows(issue)
				values = issue.try(:visible_custom_field_values) || issue.custom_field_values
				return if values.empty?

				ordered_values = []
				half = (values.size / 2.0).ceil
				half.times do |i| 
					ordered_values << values[i]
					ordered_values << values[i + half]
				end 
				s = "<tr>\n".dup
				n = 0 
				ordered_values.compact.each do |value|
					sv = ""
					if value.custom_field.field_format == Tkgmap::Identifier
						sv = show_tkgmap_value(value)
					else
						sv = simple_format_without_paragraph(h(show_value(value)))
					end

					s << "</tr>\n<tr>\n" if n > 0 && (n % 2) == 0
					s << "\t<th>#{ h(value.custom_field.name) }:</th><td>#{ sv }</td>\n"
					n += 1
				end 
				s << "</tr>\n"
				s.html_safe
			end
		end

	end
end

IssuesHelper.send(:include, TkgmapIssuesHelperPatch)
