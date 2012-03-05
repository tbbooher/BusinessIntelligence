function build_json_data
clc;
s = shaperead('cd99_110','UseGeoCoords',true);
coords = zeros(1,2);
for i = 1:length(s)
    district = s(i);
    lats = district.Lat;
    lons = district.Lon;
    lats(isnan(lats(:)))=[];
    lons(isnan(lons(:)))=[];
    d_name = district.NAME;
%     disp([num2str(district.STATE) ' -> ' get_name(district.STATE) ' ' d_name]);
    if size(d_name,2) >= 3
        if strcmp(d_name(1:3), 'One')
            state_string = 'AL';
        else
            state_string = sprintf('%02d',str2double(d_name));
        end
    else
        state_string = sprintf('%02d',str2double(d_name));
    end
    name = [get_name(str2double(district.STATE)) state_string];    
    coords(1,1:2) = meanm(lats,lons); %[lat_c, lon_c];    
    fid = fopen([name '.json'],'w');
    data.lats = lats;
    data.lons = lons;
    data.name = name;
    data.southwest = [min(lats),min(lons)];
    data.northeast = [max(lats),max(lons)];
    data.centroid = coords;
%     to_json(fid,data)
    build_json(fid,data);
    fclose(fid);    
    disp(['"' name '" => [' num2str(coords(1)) ',' num2str(coords(2)) '],']);
end % for

end % function

function build_json(fid,data)
fprintf(fid,'{\n');
fprintf(fid,['"name":"' data.name '",\n']);
fprintf(fid,'"extents": {\n');
fprintf(fid,'"southWest":{"lat":%g, "lon":%g},\n', data.southwest);
fprintf(fid,'"northEast":{"lat":%g, "lon":%g}\n', data.northeast);
fprintf(fid,'},\n');
fprintf(fid,['"centroid":{"lat":' num2str(data.centroid(1)) ', "lon":' num2str(data.centroid(2)) '},\n']);
fprintf(fid,'"coords": [\n');
for i = 1:length(data.lats)
  if i == length(data.lats)
    fprintf(fid,'{"lat":%10.10g,"lon":%10.10g}\n', data.lats(i), data.lons(i));      
  else
    fprintf(fid,'{"lat":%10.10g,"lon":%10.10g},\n', data.lats(i), data.lons(i));
  end
end % for
fprintf(fid,']\n}\n');
end

function out = get_name(idx)
names{01}='AL';
names{02}='AK';
names{04}='AZ';
names{05}='AR';
names{06}='CA';
names{08}='CO';
names{09}='CT';
names{10}='DE';
names{11}='DC';
names{12}='FL';
names{13}='GA';
names{15}='HI';
names{16}='ID';
names{17}='IL';
names{18}='IN';
names{19}='IA';
names{20}='KS';
names{21}='KY';
names{22}='LA';
names{23}='ME';
names{24}='MD';
names{25}='MA';
names{26}='MI';
names{27}='MN';
names{28}='MS';
names{29}='MO';
names{30}='MT';
names{31}='NE';
names{32}='NV';
names{33}='NH';
names{34}='NJ';
names{35}='NM';
names{36}='NY';
names{37}='NC';
names{38}='ND';
names{39}='OH';
names{40}='OK';
names{41}='OR';
names{42}='PA';
names{44}='RI';
names{45}='SC';
names{46}='SD';
names{47}='TN';
names{48}='TX';
names{49}='UT';
names{50}='VT';
names{51}='VA';
names{53}='WA';
names{54}='WV';
names{55}='WI';
names{56}='WY';
names{72}='PR';

if isa(idx,'char')
    idx = str2double(idx);
end

out = names{idx};
end