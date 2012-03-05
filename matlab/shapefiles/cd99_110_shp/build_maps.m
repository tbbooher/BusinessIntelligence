function build_maps

s = shaperead('cd99_110','UseGeoCoords',true);
coords = zeros(1,2);
for i = 1:length(s)
    district = s(i);
    lats = district.Lat;
    lons = district.Lon;
    lats(isnan(lats(:)))=[];
    lons(isnan(lons(:)))=[];
    d_name = district.NAME;
    disp([num2str(district.STATE) ' -> ' get_name(district.STATE) ' ' d_name]);
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
    disp(['"' name '" => [' num2str(coords(1)) ',' num2str(coords(2)) '],']);
end

end

function find_centroid
% now find some random points
tl = [min(lats) max(lats)];
nl = [min(lons) max(lons)];
rand_lats = tl(1) + (tl(2)-tl(1)).*rand(100,1);
rand_lons = nl(1) + (nl(2)-nl(1)).*rand(100,1);
in = inpolygon(rand_lons,rand_lats,lons,lats);
% now determine the best point inside the polygon
in_lats = rand_lats(in);
in_lons = rand_lons(in);
d         = zeros(length(lats),1);
d_min = 10^10;
for i_rand = 1:length(in_lats)
    for i_pt = 1:length(lats)
        d(i_pt) = distance(in_lats(i_rand), ...
            in_lons(i_rand), ...
            lats(i_pt), ...
            lons(i_pt));
    end
    d_avg = mean(d);
    if d_avg < d_min
        d_min = d_avg;
        point = [rand_lats(i_rand), rand_lons(i_rand)];
    end
    disp(i_rand);
end
plotm(point(1), point(2),'gx');
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