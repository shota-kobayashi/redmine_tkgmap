require_dependency 'issues_helper'

module IssuesHelperPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :render_custom_fields_rows, :tkg
		end
	end

	module InstanceMethods
		def render_custom_fields_rows_with_tkg(issue)
			return if issue.custom_field_values.empty?
			ordered_values = []
			half = (issue.custom_field_values.size / 2.0).ceil
			half.times do |i| 
				ordered_values << issue.custom_field_values[i]
				ordered_values << issue.custom_field_values[i + half]
			end 
			s = "<tr>\n"
			n = 0 
			ordered_values.compact.each do |value|
				s << "</tr>\n<tr>\n" if n > 0 && (n % 2) == 0

				if(value.custom_field.field_format == Tkgmap::Identifier && show_value(value)!="")
					latLng = show_value(value).split(",")
					script ="//<![CDATA[
						$(function(){
							setTimeout(function(){
							initMap(#{latLng[0]},#{latLng[1]}, false);
							},500);
						});
					//]]>"
				  s << javascript_include_tag('tkgmap_application',:plugin => 'redmine_tkgmap')
					s << javascript_include_tag('showMapWindow',:plugin => 'redmine_tkgmap')
					s << content_tag("script", "",{:src =>'https://maps.google.com/maps/api/js?v=3&sensor=false', :type =>'text/javascript', :charset=>'UTF-8'})
					s << "\t<th>#{ h(value.custom_field.name) }:</th><td><a href=\"https://maps.google.com/maps?q=#{latLng[0]},#{latLng[1]}\">#{ simple_format_without_paragraph(h(show_value(value))) }</a><div id=\"gmap\" style=\"width:100%;height:200px;\"></div></td>\n"
					s << content_tag("script", script,{:type =>'text/javascript'})
				else
					s << "\t<th>#{ h(value.custom_field.name) }:</th><td>#{ simple_format_without_paragraph(h(show_value(value))) }</td>\n"
				end
				n += 1
			end 
			s << "</tr>\n"
			s.html_safe
		end
	end
end

IssuesHelper.send(:include, IssuesHelperPatch)
