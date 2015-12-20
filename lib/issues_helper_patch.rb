require_dependency 'issues_helper'

module IssuesHelperPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :render_custom_fields_rows, :tkg
		end
	end

	module InstanceMethods
		def show_tkgmap_value(value)
			sv = show_value(value)
			if (value.custom_field.field_format == Tkgmap::Identifier && sv =~ /\A-?[0-9\.]+,-?[0-9\.]+\Z/)
				s = ''
				latLng = sv.split(",")
				script ="//<![CDATA[
					$(function(){
						initMap(#{latLng[0]}, #{latLng[1]}, false);
					});
				//]]>"
				s << javascript_include_tag('tkgmap_application',:plugin => 'redmine_tkgmap')
				s << javascript_include_tag('showMapWindow',:plugin => 'redmine_tkgmap')
				s << content_tag("script", "",{:src =>'https://maps.google.com/maps/api/js?v=3&sensor=false', :type =>'text/javascript', :charset=>'UTF-8'})
				s << "<a href=\"https://maps.google.com/maps?q=#{latLng[0]},#{latLng[1]}\">#{ simple_format_without_paragraph(h(show_value(value))) }</a><div id=\"gmap\" style=\"width:100%;height:200px;\"></div>"
				s << content_tag("script", script,{:type =>'text/javascript'})
				s.html_safe
			else
				sv
			end
		end
		private :show_tkgmap_value

		def render_custom_fields_rows_with_tkg(issue)
			values = issue.try(:visible_custom_field_values) || issue.custom_field_values
			return if values.empty?

			if defined? issue_fields_rows # redmine-3.x
				half = (values.size / 2.0).ceil

				issue_fields_rows do |rows|
					values.each_with_index do |value, i|
						sn = ""
						if defined? custom_field_name_tag # redmine-3.1+
							sn = custom_field_name_tag(value.custom_field)
						else # redmine-3.0
							sn = h(value.custom_field.name)
						end
						sv = ""
						if value.custom_field.field_format == Tkgmap::Identifier
							sv = show_tkgmap_value(value)
						else
							sv = simple_format_without_paragraph(h(show_value(value)))
						end

						css = "cf_#{value.custom_field.id}"
						m = (i < half ? :left : :right)
						rows.send m, sn, sv, :class => css
					end
				end
			else # redmine 2.x
				ordered_values = []
				half = (values.size / 2.0).ceil
				half.times do |i| 
					ordered_values << values[i]
					ordered_values << values[i + half]
				end 
				s = "<tr>\n"
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

IssuesHelper.send(:include, IssuesHelperPatch)
