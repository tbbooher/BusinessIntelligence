function plot_map
close all;
ax = worldmap('usa');
s = shaperead('districts','UseGeoCoords',true);
af = load_location_data;
colors = jet(8);
colors(1,:) = [1 1 1];
plotm(af.lats,af.lons,'x');
for i = 1:numel(s)
    d = s(i);
    % find auths in this state
    in = inpolygon(af.lats,af.lons,d.Lat',d.Lon');
    auths = sum(af.auths(in));
    iColor = quantize(auths);
    s(i).auths = auths;
    s(i).color_index = iColor;
    s(i).d_name = find_name(d);
    s(i).bases = load_bases(af.location_name(in));
    if auths > 0
        disp('-----------');
        disp(find_name(d));
        disp(num2str(iColor));
        disp('-----------');
    end
    try
        geoshow(ax, d,'FaceColor', colors(iColor,:));
    catch
        disp('Could not run');
        disp(find_name(d));
    end
end
shapewrite(s,'districts_with_auths');
end

function qval = quantize(val)
num_vals = 8;
max_val = 10000;
q = ceil(val*num_vals/max_val);
if q == 0 || isnan(q)
    qval = 1;
else
    qval = min(num_vals,q);
end
end

function out = load_bases(locations)
    o = strrep(savejson('eieio',locations),'"eieio": ','');
    o = regexprep(o,'\n','');
    o = regexprep(o,'\t','');    
    out = strtrim(o);
end