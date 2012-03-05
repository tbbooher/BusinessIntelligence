classdef feature < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shape
        lats
        lons
        name
        d3
        json
    end
    
    methods
        function obj = feature(f)
           obj.shape = f;
%            d3 = struct('type','Feature','properties',{},'geometry',{'type','Polygon','coordinates',[]});
           obj.lats = d.Lat(~isnan(d.Lat))';
           obj.lons = d.Lon(~isnan(d.Lon))';
           d3.type = 'Feature';
           d3.properties = [];
           d3.geometry.type = 'Polygon';
           d3.geometry.coordinates = [obj.lats obj.lons];
           obj.name = find_name(d);
           d3.id = obj.name;
           obj.d3 = d3;
%            {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-147.079854,60.200582],[-147.874011,59.784335],[-147.112716,60.381321],[-147.079854,60.200582]]]},"id":"02261"},    
           geo_json = savejson('geometry', d3.geometry);
           obj.json = json_join('{','"type":"Feature","properties":{}', geo_json);
        end
        
        function obj = plot_shape(obj)
           geoshow(obj.shape);           
        end
        
        function save_json(obj)
            fid = fopen([obj.name '.json'], 'w', 'n', 'UTF-8');
            fprintf(fid,obj.json);
            fclose(fid);
        end
        

    end
    
end

