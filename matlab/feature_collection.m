classdef feature_collection < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        feature_list
        json
    end
    
    methods
        function obj = feature_collection
%            {"type":"FeatureCollection","features":[ 
            districts = shaperead('cd99_110','UseGeoCoords',true);
            d = districts(1);
            obj.feature_list = feature(d).json;
        end
        
        function obj = save_json(obj)
            features = json_join('[',obj.feature_list);
            obj.json = json_join('{','"type":"FeatureCollection"',['"features":' features]);
            fid = fopen('features.json', 'w', 'n', 'UTF-8');
            fprintf(fid,obj.json);
            fclose(fid);            
        end
    end
    
end

