function load_district_json
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
s = shaperead('districts','UseGeoCoords',true);
af = load_location_data;
bases = shaperead('MILITARY_INSTALLATIONS_RANGES_TRAINING_AREAS_BND','UseGeoCoords',true);
for i = 1:numel(s)
   d = s(i);
   district_name = find_name(d);
   base_list = {};
   p_district = [d.Lat, d.Lon];
   j = 0;
   for iBase = 1:numel(bases)
      b = bases(iBase);
      p_base = reducem(b.Lat, b.Lon);
      if isintersect(p_base, p_district)
         j = j + 1;
         base_list{j} = b.SITE_NAME;
      end
   end
   json{i} = savejson(district_name, base_list);
end

disp(json);


end

