function load_district_json
s = shaperead('districts','UseGeoCoords',true);
% af = load_location_data;
bases = shaperead('tl_2011_us_mil','UseGeoCoords',true);
for i = 1:numel(s)
   d = s(i);
   district_name = find_name(d);
   disp(district_name);
   base_list = {};
   p_district = [d.Lat; d.Lon];
   j = 0;
   for iBase = 1:numel(bases)
      b = bases(iBase);      
      p_base = [b.Lat; b.Lon];
      if isintersect(p_base, p_district)
         j = j + 1;
         disp('-------------------------');
         disp(b.FULLNAME);
         base_list{j} = ['"' b.FULLNAME '"'];
      end
   end
   json{i} = ['"' district_name '":{"bases":[' join(',', base_list) '],"base_count":' num2str(j) '}'];
end

fid = fopen('bases_districts.json','w');
fwrite(fid, ['{' join(',',json) '}']);
fclose(fid);

end

