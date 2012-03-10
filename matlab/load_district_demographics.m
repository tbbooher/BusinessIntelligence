function load_district_demographics
s = shaperead('districts','UseGeoCoords',true);
% af = load_location_data;

% counties = shaperead('tl_2011_us_county','UseGeoCoords',true);
[district_names, data] = load_csv_demographics;
bases = shaperead('tl_2011_us_mil','UseGeoCoords',true);
for i = 1:numel(s)
   close all;
   d = s(i);
   district_name = find_name(d);
   ax = axesm ('mercator', 'Frame', 'off', 'Grid', 'off', ...
       'MapLatLimit', d.BoundingBox(:,2), 'MapLonLimit',d.BoundingBox(:,1));
   geoshow(ax,d, 'FaceColor', [200 200 200]./256);
   disp(district_name);
   p_district = [d.Lat; d.Lon];
   j = 0;
   for iBase = 1:numel(bases)
      b = bases(iBase);
      p_base = [b.Lat; b.Lon];
      if isintersect(p_base, p_district)
         j = j + 1;
         disp('-------------------------');
         disp(b.FULLNAME);
         geoshow(ax,b, 'FaceColor', [67 155 199]./256);
%          base_list{j} = ['"' b.FULLNAME '"'];
      end
   end
   iDistrict = find(strcmp(district_name,district_names));
   pop9= data(iDistrict,2);
   pop10= data(iDistrict,10);
   mil_emp_09 = data(iDistrict,7);
   mil_emp_10 = data(iDistrict,15);
   emp_percent_09 = num2str(data(iDistrict,9));
   emp_percent_10 = num2str(data(iDistrict,17));
   mil_emp_percent_09 = sprintf('%2.1f',(mil_emp_09./pop9)*100);
   mil_emp_percent_10 = sprintf('%2.1f',(mil_emp_10./pop9)*100);
   tightmap;
   saveas(gcf, [district_name '.jpg']);
   json{i} = ['"' district_name '":{"percent_military_employment_09":' mil_emp_percent_09 ...
       ',"unemployment_percent_09":' emp_percent_09 ...
       ',"unemployment_percent_10":' emp_percent_10 ...
       ',"percent_military_employment_10":' mil_emp_percent_10 ...
       ',"base_count":' num2str(j) ...       
       '}'];
end

fid = fopen('bases_districts.json','w');
fwrite(fid, ['{' join(',',json) '}']);
fclose(fid);

end

function [district_names, data] = load_csv_demographics

data = xlsread('cd_empsituation_0910.xls');
states = state_cell_array;

for iState = 2:numel(states)
  district_bignum = num2str(data(iState,1));  
  district_num = district_bignum((end-1):end);
  if strcmp(district_num,'00')
     district_num = 'AL'; 
  end
  district_names{iState} = [states{iState} district_num];
end

end

function out = state_cell_array
out = {'AL'
'AL'
'AL'
'AL'
'AL'
'AL'
'AL'
'AK'
'AZ'
'AZ'
'AZ'
'AZ'
'AZ'
'AZ'
'AZ'
'AZ'
'AR'
'AR'
'AR'
'AR'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CA'
'CO'
'CO'
'CO'
'CO'
'CO'
'CO'
'CO'
'CT'
'CT'
'CT'
'CT'
'CT'
'DE'
'DC'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'FL'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'GA'
'HI'
'HI'
'ID'
'ID'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IL'
'IN'
'IN'
'IN'
'IN'
'IN'
'IN'
'IN'
'IN'
'IN'
'IA'
'IA'
'IA'
'IA'
'IA'
'KS'
'KS'
'KS'
'KS'
'KY'
'KY'
'KY'
'KY'
'KY'
'KY'
'LA'
'LA'
'LA'
'LA'
'LA'
'LA'
'LA'
'ME'
'ME'
'MD'
'MD'
'MD'
'MD'
'MD'
'MD'
'MD'
'MD'
'MA'
'MA'
'MA'
'MA'
'MA'
'MA'
'MA'
'MA'
'MA'
'MA'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MI'
'MN'
'MN'
'MN'
'MN'
'MN'
'MN'
'MN'
'MN'
'MS'
'MS'
'MS'
'MS'
'MO'
'MO'
'MO'
'MO'
'MO'
'MO'
'MO'
'MO'
'MO'
'MT'
'NE'
'NE'
'NE'
'NV'
'NV'
'NV'
'NH'
'NH'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NJ'
'NM'
'NM'
'NM'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NY'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'NC'
'ND'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OH'
'OK'
'OK'
'OK'
'OK'
'OK'
'OR'
'OR'
'OR'
'OR'
'OR'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'PA'
'RI'
'RI'
'SC'
'SC'
'SC'
'SC'
'SC'
'SC'
'SD'
'TN'
'TN'
'TN'
'TN'
'TN'
'TN'
'TN'
'TN'
'TN'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'TX'
'UT'
'UT'
'UT'
'VT'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'VA'
'WA'
'WA'
'WA'
'WA'
'WA'
'WA'
'WA'
'WA'
'WA'
'WV'
'WV'
'WV'
'WI'
'WI'
'WI'
'WI'
'WI'
'WI'
'WI'
'WI'
'WY'
'PR'};
end