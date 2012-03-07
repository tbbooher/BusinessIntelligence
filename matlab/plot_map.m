function plot_map
close all;
ax = worldmap('usa');
s = shaperead('districts','UseGeoCoords',true);
af.lats = 25 + (55-25).*rand(100,1); % 25 to 55
af.lons = -80 + (-120+80).*rand(100,1); % -80 to -120
af.auths = randi(100,100,1);
colors = jet(10);
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
num_vals = 10;
max_val = 100;
q = ceil(val*num_vals/max_val);
if q == 0
    qval = 1;
else
    qval = min(20,q);
end
end