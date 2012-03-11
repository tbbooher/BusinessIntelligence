function load_district_demographics
clc;
s = shaperead('districts','UseGeoCoords',true);
% af = load_location_data;

% we can also pull in income (!)
% var columns = ["State","St","StCD","Hshlds09","$MHI09","Families09","$MFI09","$PCI09","FamPov09","PopPov09","Hshlds10","$MHI10","Families10","$MFI10","$PCI10","FamPov10","PopPov10","ChgMHI0910","%ChgMHI0910","ChgFamPov0910"];

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
   base_list = cell(1);
   for iBase = 1:numel(bases)
      b = bases(iBase);
      p_base = [b.Lat; b.Lon];
      if isintersect(p_base, p_district)
         j = j + 1;
         disp('-------------------------');
         disp(b.FULLNAME);
         geoshow(ax,b, 'FaceColor', [67 155 199]./256);
         base_list{j} = ['"' b.FULLNAME '"'];
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
   set(gcf,'Color','white');
   set(gca,'visible','off');
   tightmap;   
   setSizeAndSaveFigure(gcf,[200 150],[district_name '.jpg'])
%    print(gcf,'-dsvg',[district_name '.svg']);
%    saveas(gcf, [district_name '.jpg']);
   json{i} = ['"' district_name ...
       '":{"percent_military_employment_09":' mil_emp_percent_09 ...
       ',"unemployment_percent_09":' emp_percent_09 ...
       ',"unemployment_percent_10":' emp_percent_10 ...
       ',"percent_military_employment_10":' mil_emp_percent_10 ...
       ',"base_count":' num2str(j) ...
       ',"bases":[' join(',',base_list) ']' ... 
       '}'];
end

fid = fopen('bases_districts.json','w');
fwrite(fid, ['{' join(',',json) '}']);
fclose(fid);

end

function [district_names, data] = load_csv_demographics

[~, ~, raw] = xlsread('/home/bonhoffer/Sites/BusinessIntelligence/matlab/cd_empsituation_0910.xls','cd_empsituation_0910.csv');
raw = raw(2:end,3:end);
data = cell2mat(raw);
clearvars raw;

for iState = 1:length(data)
  district_bignum = num2str(data(iState,1));
  % the ugliest matlab ever written -- just trying to get 1 -> 01 and
  % 12->12
  flipped = fliplr(district_bignum);
  state_fips = sprintf('%02d',str2double(fliplr(flipped(3:end))));
  district_num = district_bignum((end-1):end);
  if strcmp(district_num,'00')
     district_num = 'AL'; 
  end
  
  district_names{iState} = [state_code(state_fips) district_num];
end

end

function out = state_code(code)

codes = {
'AK','02','	ALASKA';
'AL','01','	ALABAMA';
'AR','05','	ARKANSAS';
'AS','60','	AMERICAN SAMOA';
'AZ','04','	ARIZONA';
'CA','06','	CALIFORNIA';
'CO','08','	COLORADO';
'CT','09','	CONNECTICUT';
'DC','11','	DISTRICT OF COLUMBIA';
'DE','10','	DELAWARE';
'FL','12','	FLORIDA';
'GA','13','	GEORGIA';
'GU','66','	GUAM';
'HI','15','	HAWAII';
'IA','19','	IOWA';
'ID','16','	IDAHO';
'IL','17','	ILLINOIS';
'IN','18','	INDIANA';
'KS','20','KANSAS';
'KY','21','KENTUCKY';
'LA','22','LOUISIANA';
'MA','25','MASSACHUSETTS';
'MD','24','MARYLAND';
'ME','23','MAINE';
'MI','26','MICHIGAN';
'MN','27','MINNESOTA';
'MO','29','MISSOURI';
'MS','28','MISSISSIPPI';
'MT','30','MONTANA';
'NC','37','NORTH CAROLINA';
'ND','38','NORTH DAKOTA';
'NE','31','NEBRASKA';
'NH','33','NEW HAMPSHIRE';
'NJ','34','NEW JERSEY';
'NM','35','NEW MEXICO';
'NV','32','NEVADA';
'NY','36','NEW YORK';
'OH','39','OHIO';
'OK','40','OKLAHOMA';
'OR','41','OREGON';
'PA','42','PENNSYLVANIA';
'PR','72','PUERTO RICO';
'RI','44','RHODE ISLAND';
'SC','45','SOUTH CAROLINA';
'SD','46','SOUTH DAKOTA';
'TN','47','TENNESSEE';
'TX','48','TEXAS';
'UT','49','UTAH';
'VA','51','VIRGINIA';
'VI','78','VIRGIN ISLANDS';
'VT','50','VERMONT';
'WA','53','WASHINGTON';
'WI','55','WISCONSIN';
'WV','54','WEST VIRGINIA';
'WY','56','WYOMING';
};

out = codes{strcmp(codes(:,2),code),1};

end

function setSizeAndSaveFigure(f,jpegSize,jpegFile)
%setSizeAndSaveFigure set the figure size and then saves to a JPEG

    origFigurePos = getpixelposition(f);
    setpixelposition(f,[origFigurePos(1:2),jpegSize]);
    
    F = getframe(f);
    
    im = frame2im(F);
    
    imwrite(im,jpegFile,'jpg');
    
    setpixelposition(f,origFigurePos);
    
    drawnow;
end 