s = shaperead('cd99_110','UseGeoCoords',true);

for i = 1:numel(s)
   d = s(i);
   [lat, lon] = reducem(d.Lat',d.Lon');
   s(i).Lat = lat';
   s(i).Lon = lon';
end

shapewrite(s,'districts');