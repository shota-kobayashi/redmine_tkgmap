# redmine_tkgmap  
Adding a custom field that can choose latitude/longitude of location using google maps.  

----

##Installation
Just put this plugin to plugin dir, and then you can select this custom field.


```
    cd plugins  
    git clone git://github.com/shota-kobayashi/redmine_tkgmap  
    bundle install  
```
Note: I restarted ALL the bitnami redmine stack on winxp.
TODO: Need to check if this is **required**  

----
##Using LatLng custom field
Create new "Custom Field" of type "LatLng" from Admininstration->"Custom Fields"->"New Custom Field".  
a) Need to select "Format" as "LatLng".  
b) Need to select your "project" name to add the custom field to your specific project.  
c) Optionally also give default value to the custom field.  
This is to avoid problems with existing Issues with new custom field but no value.  
d) Can also opt for 'required' setting for custom field.  
e) Optionally select 'searchable' setting for custom field. Allows using custom-field as filter in search/custom-queries.  

----
## ScreenShots
![Issue with inline map and location field](https://raw.github.com/shota-kobayashi/redmine_tkgmap/master/assets/images/ss2.jpg)  
  
![Update Issue with modifiable location in popup window](https://raw.github.com/shota-kobayashi/redmine_tkgmap/master/assets/images/ss1.jpg)  
  
![Configure Default settings for tkgmap](https://raw.github.com/shota-kobayashi/redmine_tkgmap/master/assets/images/ss3.jpg)  
  
----
